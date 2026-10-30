-- Vale Sangora Map: draws the community map's markers on the game's own M map.
-- Lua only: Data\markers.txt (categories + world positions), Icons\<category>.png.
--
-- How it sits on the game map: the map places its own pins inside its pin container at
-- WorldToMapPosition(world), and that position is proportional to the zoom (zoom 10 -> 19235,
-- zoom 6.4 -> 12310). So all our markers live in ONE canvas layer inside that container, laid out
-- once at a reference zoom Z0; when the zoom changes only the layer's render scale changes
-- (one call), which keeps every marker glued to the map with no lag. Icon size is corrected
-- afterwards, once the zoom has settled.
local UEHelpers = require("UEHelpers.UEHelpers")

local MOD = (debug.getinfo(1, "S").source or ""):gsub("^@", ""):gsub("[\\/][^\\/]*$", ""):gsub("[\\/]Scripts$", "")
local ICON_FALLBACK = 56          -- icon size in map units when the game's pins cannot be measured
local iconBase = nil              -- size of the game's own pins, measured on the map (map units)
local iconScale = 1.0             -- user setting from the panel (SIZE - / +)
local function iconUnits()
    return (iconBase or ICON_FALLBACK) * iconScale
end
local DONE_OPACITY = 0.3
local BUILD_PER_TICK = 60     -- widgets created per tick while the layer is (re)built (1799 in ~0.5 s, no hitch)
local RESIZE_PER_TICK = 300   -- icons resized per tick after a zoom change
local TICK_MS = 33            -- update interval
local TEXTURES_PER_TICK = 6   -- icon files loaded per tick while the layer is built (no single big hitch)
local LOG_FILE = MOD .. "\\vsm.log"

local function log(s) print("[ValeSangoraMap] " .. s .. "\n") end
local logLines = {}
local function note(s)
    log(s)
    if #logLines >= 200 then return end
    logLines[#logLines + 1] = os.date("%H:%M:%S ") .. s
    local f = io.open(LOG_FILE, "w")
    if f then f:write(table.concat(logLines, "\n") .. "\n"); f:close() end
end

-- ---------------------------------------------------------------------------------------------
-- Pinned functions. UE4SS keeps a function we hand it (update loop, hooks, key binds) only as a
-- reference. When Lua's garbage collector frees that function, UE4SS throws "Ref was not function"
-- and drops this mod's whole tick: the panel freezes. Other UE4SS mods for this game work around
-- the same fault. So every function given to UE4SS is created ONCE and kept here; nothing is ever
-- passed as a fresh closure, and the garbage the panel makes can no longer free one of them.
-- ---------------------------------------------------------------------------------------------
local pinned = {}
local function pin(fn)
    pinned[#pinned + 1] = fn
    return fn
end

-- ---------------------------------------------------------------------------------------------
-- Crash guard. Lua errors are caught everywhere (pcall) and counted: a burst of them pauses the mod
-- for 30 s instead of hammering the game. A native crash cannot be caught, so every heavy step
-- leaves a breadcrumb in guard.txt ("idle" when nothing runs). If the game died during a step, the
-- next start logs which one and runs that session in safe mode: smaller batches, slower clicks.
-- ---------------------------------------------------------------------------------------------
local GUARD = MOD .. "\\guard.txt"
local safeMode = false
do
    local f = io.open(GUARD, "r")
    if f then
        local last = f:read("*l")
        f:close()
        if last and last ~= "" and last ~= "idle" then
            safeMode = true
            note("previous session ended during: " .. last .. " (safe mode for this session)")
        end
    end
end
local crumbNow = false
local function crumb(op)
    op = op or "idle"
    if op == crumbNow then return end
    crumbNow = op
    local f = io.open(GUARD, "w")
    if f then f:write(op .. "\n"); f:close() end
end
crumb(nil)
-- run fn(...) protected, with a breadcrumb around it
local function guarded(op, fn, ...)
    crumb(op)
    local ok, err = pcall(fn, ...)
    crumb(nil)
    return ok, err
end
local errTimes, pausedUntil = {}, 0
local function countError(where, err)
    note(where .. " error: " .. tostring(err))
    local now = os.clock()
    errTimes[#errTimes + 1] = now
    while errTimes[1] and errTimes[1] < now - 10 do table.remove(errTimes, 1) end
    if #errTimes >= 10 then
        errTimes, pausedUntil = {}, now + 30
        note("too many errors, paused for 30 s")
    end
end
if safeMode then BUILD_PER_TICK = 25 end
local APPLY_PER_TICK = safeMode and 100 or 300
local CLICK_GAP = safeMode and 0.5 or 0.2

-- ---------------------------------------------------------------------------------------------
-- Data
-- ---------------------------------------------------------------------------------------------
local cats, catOrder, markers = {}, {}, {}
local parentList = {}             -- { key, title, children = { cat keys } } in the web app's order
do
    local f = io.open(MOD .. "\\Data\\markers.txt", "r")
    if not f then note("Data\\markers.txt missing") else
        for line in f:lines() do
            if line:sub(1, 8) == "#parent\t" then
                local key, title = line:match("^#parent\t([^\t]+)\t(.*)$")
                if key then parentList[#parentList + 1] = { key = key, title = title, children = {} } end
            elseif line:sub(1, 5) == "#cat\t" then
                local key, parent, title = line:match("^#cat\t([^\t]+)\t([^\t]*)\t(.*)$")
                if key then cats[key] = { parent = parent, title = title, on = true }; catOrder[#catOrder + 1] = key end
            elseif line:sub(1, 1) ~= "#" then
                local key, x, y, id, title = line:match("^([^\t]+)\t([-%d]+)\t([-%d]+)\t(%d+)\t(.*)$")
                if key and cats[key] then
                    markers[#markers + 1] = { cat = key, x = tonumber(x), y = tonumber(y), id = tonumber(id), title = title }
                end
            end
        end
        f:close()
    end
    note(string.format("version 1.0.3, loaded %d categories, %d markers", #catOrder, #markers))
end

-- Progress: ids of markers marked done, one per line (Mods\ValeSangoraMap\progress.txt)
local PROGRESS = MOD .. "\\progress.txt"
local done = {}
do
    local f = io.open(PROGRESS, "r")
    if f then for line in f:lines() do local id = tonumber(line) if id then done[id] = true end end f:close() end
end
local function saveProgress()
    local ids = {}
    for id in pairs(done) do ids[#ids + 1] = tostring(id) end
    table.sort(ids)
    local f = io.open(PROGRESS, "w")
    if f then f:write(table.concat(ids, "\n") .. "\n"); f:close() end
end

-- ---------------------------------------------------------------------------------------------
-- Game map access
-- ---------------------------------------------------------------------------------------------
local function addrRaw(w) return w:GetAddress() end
local function nameRaw(w) return w:GetFullName() end
local function addrOf(w)
    local ok, a = pcall(addrRaw, w)
    if ok and a then return a end
    local ok2, n = pcall(nameRaw, w)
    return ok2 and n or tostring(w)
end

local function activeRaw(w) return w:IsValid() and w:IsActivated() end
local function isOpen(w)
    local ok, a = pcall(activeRaw, w)
    return ok and a
end

-- The map widget is one persistent object. Once it has been seen on screen after a save load it is
-- only asked "are you open" (two cheap calls). FindAllOf walks every object of the game, so it runs
-- every 5 s only while no map has been seen yet, then once a minute as a safety net, and a slow
-- search is written to the log.
local mapList, mapListAt = {}, 0
local mapSeen = false              -- a map widget was on screen since the last forget()
local scanNotes, scanCount = 0, 0
local function openMap()
    for _, w in ipairs(mapList) do
        if isOpen(w) then mapSeen = true return w end
    end
    if os.clock() < mapListAt then return nil end
    mapListAt = os.clock() + (mapSeen and 60 or 5)
    local t0 = os.clock()
    mapList = {}
    for _, w in ipairs(FindAllOf("WBP_Map_C") or {}) do
        if w:IsValid() then mapList[#mapList + 1] = w end
    end
    scanCount = scanCount + 1
    local ms = (os.clock() - t0) * 1000
    if ms > 15 and scanNotes < 5 then
        scanNotes = scanNotes + 1
        note(string.format("slow object search: %.0f ms (search %d)", ms, scanCount))
    end
    for _, w in ipairs(mapList) do
        if isOpen(w) then mapSeen = true return w end
    end
    return nil
end

local textures = {}
local renderLib = nil
local importsThisTick = 0
local function texture(cat)
    local t = textures[cat]
    if t and t:IsValid() then return t end
    importsThisTick = importsThisTick + 1
    renderLib = renderLib or StaticFindObject("/Script/Engine.Default__KismetRenderingLibrary")
    local ok, tex = pcall(function() return renderLib:ImportFileAsTexture2D(UEHelpers.GetGameInstance(), MOD .. "\\Icons\\" .. cat .. ".png") end)
    if ok and tex and tex:IsValid() then textures[cat] = tex return tex end
    return nil
end

-- every object name carries a token of this run: after a mod reload the counters restart, and
-- constructing an object under the name of one that still exists is a fatal engine error
math.randomseed(os.time())
local RUN = string.format("%x%x", os.time() % 0xFFFFFF, math.random(0, 0xFFFF))
local function construct(classPath, outer, name)
    return StaticConstructObject(StaticFindObject(classPath), outer, FName(name .. "_" .. RUN))
end

-- widgets an earlier run of this mod left behind (mod reload): removed before drawing new ones
local function removeLeftovers(panel, prefix)
    local n = 0
    pcall(function()
        for i = panel:GetChildrenCount() - 1, 0, -1 do
            local ch = panel:GetChildAt(i)
            if ch and ch:IsValid() and ch:GetFName():ToString():sub(1, #prefix) == prefix then
                ch:RemoveFromParent()
                n = n + 1
            end
        end
    end)
    return n
end

-- ---------------------------------------------------------------------------------------------
-- Layer
-- ---------------------------------------------------------------------------------------------
local L = {
    map = nil, layer = nil, z0 = nil, affine = nil, serial = 0,
    built = 0, items = {}, zoom = nil, sizeZoom = nil, settleAt = nil, resizeAt = 1,
}

local function attached()
    if not (L.layer and L.map) then return false end
    local ok, same = pcall(function()
        return L.layer:IsValid() and L.layer:GetParent():GetFullName() == L.map:GetMappinContainer():GetFullName()
    end)
    return ok and same
end

-- world -> map position at zoom z0, as an affine fitted on three WorldToMapPosition samples
local function fitAffine(map)
    local function at(x, y) local p = map:WorldToMapPosition({ X = x, Y = y, Z = 0 }) return p.X, p.Y end
    local ox, oy = at(0, 0)
    local ax, ay = at(100000, 0)
    local bx, by = at(0, 100000)
    return { a = (ax - ox) / 1e5, b = (bx - ox) / 1e5, c = ox, d = (ay - oy) / 1e5, e = (by - oy) / 1e5, f = oy }
end

local function startLayer(map)
    -- drop the previous layer, otherwise old layers keep drawing at their old scale
    if L.layer then pcall(function() L.layer:RemoveFromParent() end) end
    for k in pairs(textures) do textures[k] = nil end
    L.serial = L.serial + 1
    L.map, L.mapAddr, L.items, L.built, L.resizeAt = map, addrOf(map), {}, 0, 1
    L.z0 = map:GetCurrentZoom()
    L.zoom, L.sizeZoom = L.z0, L.z0
    L.affine = fitAffine(map)
    local container = map:GetMappinContainer()
    local old = removeLeftovers(container, "VSM_Layer_")
    if old > 0 then note("removed " .. old .. " old marker layer(s)") end
    L.pending, L.applyAt, L.hits, L.hot, L.panel, L.panelBg = nil, nil, nil, nil, nil, nil
    L.panelSwept, L.scanLeft, L.hoverDirty, L.attachCheckAt, L.sigMoves = nil, 0, true, nil, nil
    L.layer = construct("/Script/UMG.CanvasPanel", map.WidgetTree, "VSM_Layer_" .. L.serial)
    local slot = container:AddChildToCanvas(L.layer)
    slot:SetAutoSize(false)
    slot:SetPosition({ X = 0, Y = 0 })
    -- as big as the whole map at z0, so no child is ever outside its parent
    local ms = { X = 40000, Y = 40000 }
    pcall(function() local v = map:GetMapSize(); ms = { X = v.X * 1.2, Y = v.Y * 1.2 } end)
    slot:SetSize(ms)
    L.layer:SetVisibility(4)                       -- SelfHitTestInvisible: only the icons are hit-tested
    L.layer:SetRenderTransformPivot({ X = 0, Y = 0 })
    L.hover, L.tip, L.panel, L.scanAt = nil, nil, nil, 1
    note(string.format("layer created at zoom %.3f, building %d markers", L.z0, #markers))
end

-- ---------------------------------------------------------------------------------------------
-- Filters, as in the web app: every category on/off (a parent row toggles all its children) and
-- what to do with finished markers. Saved in settings.txt.
-- ---------------------------------------------------------------------------------------------
local SETTINGS = MOD .. "\\settings.txt"
local doneMode = "all"            -- all | finished | ongoing
local doneStyle = "faded"         -- finished markers under All: faded | hidden
do
    local byTitle = {}
    for _, pr in ipairs(parentList) do byTitle[pr.title] = pr end
    for _, k in ipairs(catOrder) do
        local pr = byTitle[cats[k].parent]
        if not pr then
            pr = { key = k, title = cats[k].parent, children = {} }
            parentList[#parentList + 1] = pr
            byTitle[pr.title] = pr
        end
        pr.children[#pr.children + 1] = k
    end
    local f = io.open(SETTINGS, "r")
    if f then
        for line in f:lines() do
            local off = line:match("^off\t(.+)$")                 -- older settings: a whole parent
            if off and byTitle[off] then for _, k in ipairs(byTitle[off].children) do cats[k].on = false end end
            local oc = line:match("^offcat\t(.+)$")
            if oc and cats[oc] then cats[oc].on = false end
            local dm = line:match("^done\t(%a+)$")
            if dm then doneMode = ({ faded = "all", shown = "all", hidden = "ongoing" })[dm] or dm end
            local st = line:match("^style\t(%a+)$")
            if st == "faded" or st == "hidden" then doneStyle = st end
            local sz = tonumber(line:match("^size\t([%d.]+)$") or "")
            if sz then iconScale = math.max(0.5, math.min(2, sz)) end
        end
        f:close()
    end
end
local function saveSettings()
    local out = { "done\t" .. doneMode, "style\t" .. doneStyle, string.format("size\t%.2f", iconScale) }
    for _, k in ipairs(catOrder) do if not cats[k].on then out[#out + 1] = "offcat\t" .. k end end
    local f = io.open(SETTINGS, "w")
    if f then f:write(table.concat(out, "\n") .. "\n"); f:close() end
end

local function shown(it)
    if not cats[it.m.cat].on then return false end
    if doneMode == "finished" then return done[it.m.id] == true end
    if doneMode == "ongoing" or doneStyle == "hidden" then return not done[it.m.id] end
    return true
end

local function applyRaw(img, vis, opacity)
    img:SetVisibility(vis)
    img:SetRenderOpacity(opacity)
end

local function applyItem(it)
    local isDone = done[it.m.id]
    pcall(applyRaw, it.img, shown(it) and 0 or 1, (isDone and doneMode == "all") and DONE_OPACITY or 1)
end
local function applyAll()
    for i = 1, L.built do if L.items[i] then applyItem(L.items[i]) end end
end

local function buildOne(i, m)
    local img = construct("/Script/UMG.Image", L.map.WidgetTree, "VSM_M" .. L.serial .. "_" .. i)
    local tex = texture(m.cat)
    if tex then img:SetBrushFromTexture(tex, false) end
    local slot = L.layer:AddChildToCanvas(img)
    local a = L.affine
    local lx, ly = a.a * m.x + a.b * m.y + a.c, a.d * m.x + a.e * m.y + a.f
    slot:SetAlignment({ X = 0.5, Y = 0.5 })
    slot:SetPosition({ X = lx, Y = ly })
    local s = iconUnits() * L.z0 / L.zoom
    slot:SetSize({ X = s, Y = s })
    L.items[i] = { img = img, slot = slot, lx = lx, ly = ly, m = m }
    applyItem(L.items[i])
end

local function buildStep()
    crumb("building markers")
    local n = 0
    while L.built < #markers and n < BUILD_PER_TICK do
        local m = markers[L.built + 1]
        -- loading icon files is the slow part: a few per tick, the rest of the markers wait
        if not textures[m.cat] and importsThisTick >= TEXTURES_PER_TICK then break end
        L.built = L.built + 1
        n = n + 1
        local ok, err = pcall(buildOne, L.built, m)
        if not ok and L.built < 3 then note("marker build failed: " .. tostring(err)) end
    end
    if L.built >= #markers then
        note("all markers built")
        crumb(nil)
        L.sizeZoom, L.settleAt = nil, os.clock()
    end
end

-- every frame we get: follow the zoom with one render-scale call
local function followZoom()
    local z = L.map:GetCurrentZoom()
    if z ~= L.zoom then
        L.zoom = z
        local s = z / L.z0
        L.layer:SetRenderScale({ X = s, Y = s })
        L.settleAt = os.clock() + 0.3
    end
end

-- The game's pins are not scaled by the zoom; their on-screen size is desired size * render scale.
local measureNotes = 0
local function measurePins()
    local c = L.map:GetMappinContainer()
    local sizes = {}
    local n = c:GetChildrenCount()
    for i = 0, n - 1 do
        if #sizes >= 25 then break end
        pcall(function()
            local ch = c:GetChildAt(i)
            if not (ch and ch:IsValid() and ch:IsVisible()) then return end
            if ch:GetClass():GetFName():ToString() ~= "WBP_Map_Mappin_C" then return end
            local inner = ch.WBP_Mappin
            local w = (inner and inner:IsValid()) and inner or ch
            local d = w:GetDesiredSize()
            local sc = ch.RenderTransform.Scale.X * ((w ~= ch) and w.RenderTransform.Scale.X or 1)
            local v = math.max(d.X, d.Y) * sc
            if v > 4 and v < 400 then sizes[#sizes + 1] = v end
        end)
    end
    if #sizes < 3 then return end
    table.sort(sizes)
    local m = sizes[math.floor(#sizes / 2) + 1]
    if measureNotes < 6 then
        measureNotes = measureNotes + 1
        note(string.format("game pin size %.1f (n %d, min %.1f, max %.1f) at zoom %.3f", m, #sizes, sizes[1], sizes[#sizes], L.zoom))
    end
    if not iconBase or math.abs(m - iconBase) > 0.5 then
        iconBase = m
        L.sizeZoom = nil              -- forces a resize pass
        L.settleAt = L.settleAt or os.clock()
    end
end

-- after the zoom settled: give every icon its on-screen size again (spread over ticks)
local function resizeOne(slot, s) slot:SetSize({ X = s, Y = s }) end
local function resizeStep()
    if not L.settleAt or os.clock() < L.settleAt then return end
    if L.resizeAt == 1 then pcall(measurePins) end
    if L.sizeZoom == L.zoom then L.settleAt = nil return end
    local s = iconUnits() * L.z0 / L.zoom
    local n = 0
    while L.resizeAt <= L.built and n < RESIZE_PER_TICK do
        local it = L.items[L.resizeAt]
        if it then pcall(resizeOne, it.slot, s) end
        L.resizeAt = L.resizeAt + 1
        n = n + 1
    end
    if L.resizeAt > L.built then L.resizeAt, L.sizeZoom, L.settleAt = 1, L.zoom, nil end
end

-- ---------------------------------------------------------------------------------------------
-- Hover and right click. Slate itself tells which icon is under the mouse (IsHovered), so no
-- screen -> map math is needed. Icons are checked in a rolling window, the hovered one every tick.
-- ---------------------------------------------------------------------------------------------
local SCAN_PER_TICK = safeMode and 60 or 150

-- Text size: the font struct is never written from Lua (copying FSlateFontInfo through the wrapper
-- is unsafe). The text keeps the default font; its laid-out height is measured and the wanted size
-- is reached with a render scale around the text's anchor. Returns that scale.
local fontH, digitW = nil, nil     -- default font: line height and width of a digit, measured once
local function measureFont(t)
    pcall(function()
        t:SetText(FText("0123456789"))
        t:ForceLayoutPrepass()
        local d = t:GetDesiredSize()
        if d.Y > 0 then fontH, digitW = d.Y, d.X / 10 end
        note(string.format("default text: height %.1f, digit %.1f", d.Y, d.X / 10))
    end)
end
local function fitFont(t, size, alignX)
    if not fontH then
        local keep = t:GetText()
        measureFont(t)
        t:SetText(keep)
    end
    local k = 1
    if fontH then k = size * 1.4 / fontH end
    if k ~= 1 then
        t:SetRenderTransformPivot({ X = alignX or 0, Y = 0 })
        t:SetRenderScale({ X = k, Y = k })
    end
    return k
end

local function ensureTip()
    if L.tip and L.tip:IsValid() then return L.tip end
    local t = construct("/Script/UMG.TextBlock", L.map.WidgetTree, "VSM_Tip_" .. L.serial .. "_" .. os.clock())
    local slot = L.layer:AddChildToCanvas(t)
    slot:SetAutoSize(true)
    pcall(function() t:SetShadowOffset({ X = 2, Y = 2 }) end)
    pcall(function() t:SetShadowColorAndOpacity({ R = 0, G = 0, B = 0, A = 1 }) end)
    t:SetColorAndOpacity({ SpecifiedColor = { R = 1, G = 0.95, B = 0.85, A = 1 }, ColorUseRule = 0 })
    t:SetVisibility(3)
    t:SetText(FText("Ag"))
    L.tipK = fitFont(t, 20, 0)
    t:SetRenderTransformPivot({ X = 0, Y = 0 })
    L.tip = t
    return t
end

local function hoveredRaw(img) return img:IsHovered() end
local function isHovered(it)
    local ok, h = pcall(hoveredRaw, it.img)
    return ok and h == true
end

local function showTip(it)
    L.hover = it
    local tip = ensureTip()
    if not it then tip:SetVisibility(1) return end
    local scale = L.zoom / L.z0
    local half = iconUnits() * 0.5 / scale
    local text = it.m.title .. "  (" .. cats[it.m.cat].title .. ")" .. (done[it.m.id] and "  - done" or "") .. "\n" .. "Click: mark done / undo"
    tip:SetText(FText(text))
    tip.Slot:SetPosition({ X = it.lx + half, Y = it.ly - half })
    local k = (L.tipK or 1) / scale
    tip:SetRenderScale({ X = k, Y = k })
    tip:SetVisibility(3)
end

local hoverSeen = false
local function hoverStep()
    -- the mouse and the map have not moved since the last full pass: nothing new to find
    if (L.scanLeft or 0) <= 0 then return end
    if L.hover then
        if shown(L.hover) and isHovered(L.hover) then L.scanLeft = 0 return end
        showTip(nil)
    end
    local n = 0
    while n < SCAN_PER_TICK and L.built > 0 do
        if not L.scanAt or L.scanAt > L.built then L.scanAt = 1 end
        local it = L.items[L.scanAt]
        L.scanAt, n = L.scanAt + 1, n + 1
        L.scanLeft = L.scanLeft - 1
        if it and shown(it) and isHovered(it) then
            if not hoverSeen then hoverSeen = true note("hover works: " .. it.m.title) end
            showTip(it)
            L.scanLeft = 0
            return
        end
    end
end

-- full pass, used when a click comes before the rolling scan reached the icon
local function findHovered()
    for i = 1, L.built do
        local it = L.items[i]
        if it and shown(it) and isHovered(it) then return it end
    end
end

local function viewCenter()
    local ok, c = pcall(function() local v = L.map:GetMapPointInViewCenter() return { X = v.X, Y = v.Y } end)
    return ok and c or nil
end

local function toggleHovered()
    local it = L.hover
    if not (it and isHovered(it)) then it = findHovered() end
    if not it then return end
    L.pending = { it = it, at = os.clock() + 0.25, center = viewCenter(), zoom = L.zoom }
end

local function pendingStep()
    local pd = L.pending
    if not pd or os.clock() < pd.at then return end
    L.pending = nil
    local c = viewCenter()
    if pd.zoom ~= L.zoom then return end
    if pd.center and c and (math.abs(c.X - pd.center.X) > 2 or math.abs(c.Y - pd.center.Y) > 2) then return end
    local it = pd.it
    if not (it and it.img and it.img:IsValid()) then return end
    local id = it.m.id
    if done[id] then done[id] = nil else done[id] = true end
    applyItem(it)
    saveProgress()
    if L.panel then L.panelDirty = true end
    L.hoverDirty = true
    showTip(shown(it) and it or nil)
end

-- ---------------------------------------------------------------------------------------------
-- Filter panel on the game's map screen (top left), built like the web app's sidebar: Markers
-- Hide / Show, Show All | Finished | Ongoing, progress, then the category tree with icons and
-- done / total counts. Every button is an image Slate hit-tests; a left click runs the hovered one.
-- ---------------------------------------------------------------------------------------------
local PX, PY, PW, PAD = 16, 24, 420, 12
local UI_SCALE = 1.45            -- the whole panel is drawn at this scale (render transform, hit tests follow it)
local ROW = 28

-- UMG colours are linear; the palette (web app style.css) is sRGB hex
local function lin(hex, a)
    local function ch(i)
        local c = tonumber(hex:sub(i, i + 1), 16) / 255
        return c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
    end
    return { R = ch(1), G = ch(3), B = ch(5), A = a or 1 }
end
local C = {
    bg = lin("141514", 0.89), panel = lin("2c2e35"), panel2 = lin("363943"), line = lin("465670"),
    text = lin("c9d3e3"), muted = lin("8593a8"), accent = lin("4b72d4"), ok = lin("719a47"),
    bad = lin("a65d5c", 0.95), hover = lin("465670", 0.75), press = lin("4b72d4"), badText = lin("c9807f"), white = lin("ffffff"), none = lin("000000", 0),
}

local function counts()
    local tot, dn, all, got = {}, {}, 0, 0
    for _, m in ipairs(markers) do
        tot[m.cat] = (tot[m.cat] or 0) + 1
        all = all + 1
        if done[m.id] then dn[m.cat] = (dn[m.cat] or 0) + 1 got = got + 1 end
    end
    return tot, dn, all, got
end

-- the topmost panel of the map screen: walk up from the pin container
local function screenRoot()
    local w = L.map:GetMappinContainer()
    for _ = 1, 30 do
        local ok, parent = pcall(function() return w:GetParent() end)
        if not (ok and parent and parent:IsValid()) then break end
        w = parent
    end
    return w
end

local uid = 0
local function name(prefix) uid = uid + 1 return prefix .. L.serial .. "_" .. uid end

local function fillSlot(slot)
    pcall(function() slot:SetAnchors({ Minimum = { X = 0, Y = 0 }, Maximum = { X = 1, Y = 1 } }) end)
    pcall(function() slot:SetOffsets({ Left = 0, Top = 0, Right = 0, Bottom = 0 }) end)
    pcall(function() slot:SetHorizontalAlignment(0) end)
    pcall(function() slot:SetVerticalAlignment(0) end)
end

local P = nil   -- panel being built: { canvas, hits }
local function rect(x, y, w, h, color, hit)
    local img = construct("/Script/UMG.Image", L.map.WidgetTree, name("VSM_Box_"))
    local slot = P.canvas:AddChildToCanvas(img)
    slot:SetPosition({ X = PX + x, Y = PY + y })
    slot:SetSize({ X = w, Y = h })
    img:SetColorAndOpacity(color)
    img:SetVisibility(hit and 0 or 3)
    return img
end
-- 1 px frame, like the web app's bordered boxes and buttons
local function frame(x, y, w, h, color)
    rect(x, y, w, 1, color) rect(x, y + h - 1, w, 1, color)
    rect(x, y, 1, h, color) rect(x + w - 1, y, 1, h, color)
end
local function text(x, y, str, color, size, align, opacity)
    local t = construct("/Script/UMG.TextBlock", L.map.WidgetTree, name("VSM_Txt_"))
    local slot = P.canvas:AddChildToCanvas(t)
    slot:SetAutoSize(true)
    slot:SetAlignment({ X = align or 0, Y = 0 })
    slot:SetPosition({ X = PX + x, Y = PY + y })
    t:SetColorAndOpacity({ SpecifiedColor = color, ColorUseRule = 0 })
    t:SetText(FText(str))
    local k = fitFont(t, size or 13, align or 0)
    if opacity then t:SetRenderOpacity(opacity) end
    t:SetVisibility(3)
    return t, #str * (digitW or 14) * k
end
local function icon(x, y, size, key, opacity)
    local tex = texture(key)
    if not tex then return end
    local img = construct("/Script/UMG.Image", L.map.WidgetTree, name("VSM_Ico_"))
    local slot = P.canvas:AddChildToCanvas(img)
    slot:SetPosition({ X = PX + x, Y = PY + y })
    slot:SetSize({ X = size, Y = size })
    img:SetBrushFromTexture(tex, false)
    img:SetRenderOpacity(opacity or 1)
    img:SetVisibility(3)
end
-- a clickable area: base colour, hover colour, action
local function hit(x, y, w, h, base, hover, action, rmb)
    local img = rect(x, y, w, h, base, true)
    P.hits[#P.hits + 1] = { img = img, base = base, hover = hover, action = action, rmb = rmb }
end
local function button(x, y, w, h, label, on, action)
    hit(x, y, w, h, on and C.accent or C.panel2, on and C.accent or C.line, action)
    if not on then frame(x, y, w, h, C.line) end
    text(x + w / 2, y + (h - 17) / 2, label, on and C.white or C.text, 12, 0.5)
end
-- done / total, green / red, all green when complete (web app .cnt)
local function count(xRight, y, d, t)
    if t > 0 and d >= t then text(xRight, y, d .. "/" .. t, C.ok, 12, 1) return end
    local _, w = text(xRight, y, tostring(t), C.badText, 12, 1)
    local _, w2 = text(xRight - w, y, "/", C.muted, 12, 1)
    text(xRight - w - w2, y, tostring(d), C.ok, 12, 1)
end

local function refilter()
    saveSettings()
    L.applyAt = 1
    L.hoverDirty = true
    if L.hover then showTip(nil) end
end

local function markAll(keys)
    return function()
        local set, complete = {}, true
        for _, k in ipairs(keys) do set[k] = true end
        for _, m in ipairs(markers) do if set[m.cat] and not done[m.id] then complete = false break end end
        for _, m in ipairs(markers) do if set[m.cat] then done[m.id] = (not complete) or nil end end
        saveProgress()
        L.applyAt = 1
        L.hoverDirty = true
        if L.hover then showTip(nil) end
    end
end

local function anyOn(pr)
    for _, k in ipairs(pr.children) do if cats[k].on then return true end end
    return false
end

-- one labelled line of the panel: dark box, label on the left
local function panelLine(y, label)
    rect(6, y, PW - 12, 34, C.panel)
    text(PAD + 2, y + 8, label, C.text, 13)
end

local function buildPanel()
    if L.panel and L.panel:IsValid() then pcall(function() L.panel:RemoveFromParent() end) end
    L.panel, L.hits, L.hot = nil, {}, nil
    local root = screenRoot()
    if not L.panelSwept then L.panelSwept = true removeLeftovers(root, "VSM_Panel_") end
    local canvas = construct("/Script/UMG.CanvasPanel", L.map.WidgetTree, name("VSM_Panel_"))
    fillSlot(root:AddChild(canvas))
    canvas:SetVisibility(4)            -- SelfHitTestInvisible: only the panel's own areas take the mouse
    canvas:SetRenderTransformPivot({ X = 0, Y = 0 })
    canvas:SetRenderScale({ X = UI_SCALE, Y = UI_SCALE })
    P = { canvas = canvas, hits = L.hits }

    local tot, dn, all, got = counts()
    -- category list as in the web app: groups, the opened group's categories under it
    local rows = {}
    for _, pr in ipairs(parentList) do
        rows[#rows + 1] = { parent = pr }
        if pr.key == L.openKey then for _, k in ipairs(pr.children) do rows[#rows + 1] = { cat = k, parent = pr } end end
    end
    local listY = 262
    local height = L.collapsed and 36 or (listY + #rows * ROW + 8)
    L.panelBg = rect(0, 0, PW, height, C.bg, true)        -- background, keeps clicks off the map
    frame(0, 0, PW, height, C.line)

    -- title bar: collapse
    hit(1, 1, PW - 2, 34, C.panel, C.hover, function() L.collapsed = not L.collapsed end)
    text(PAD, 8, "VALE SANGORA MAP", C.accent, 14)
    text(PW - PAD, 6, L.collapsed and "+" or "-", C.text, 15, 1)

    if not L.collapsed then
        local bx = 150                                     -- buttons start here on every line
        -- progress, a line of its own
        text(PAD + 2, 44, "Progress", C.text, 13)
        text(PW - PAD, 45, got .. " / " .. all, C.muted, 12, 1)
        rect(PAD, 66, PW - PAD * 2, 8, C.bad)
        if got > 0 then rect(PAD, 66, math.max(2, (PW - PAD * 2) * got / all), 8, C.ok) end
        -- Markers   [Hide] [Show]
        panelLine(84, "Markers")
        button(bx, 88, 80, 26, "Hide", false, function() for _, k in ipairs(catOrder) do cats[k].on = false end refilter() end)
        button(bx + 84, 88, 80, 26, "Show", false, function() for _, k in ipairs(catOrder) do cats[k].on = true end refilter() end)
        -- Show   All | Finished | Ongoing
        panelLine(122, "Show")
        local x = bx
        for _, md in ipairs({ { "all", "All", 60 }, { "finished", "Finished", 84 }, { "ongoing", "Ongoing", 84 } }) do
            button(x, 126, md[3], 26, md[2], doneMode == md[1], function() doneMode = md[1] refilter() end)
            x = x + md[3] + 4
        end
        -- Finished markers   [Faded] [Hidden]
        panelLine(160, "Finished markers")
        button(bx, 164, 80, 26, "Faded", doneStyle == "faded", function() doneStyle = "faded" refilter() end)
        button(bx + 84, 164, 80, 26, "Hidden", doneStyle == "hidden", function() doneStyle = "hidden" refilter() end)
        -- Icon size   [ + ] 100% [ - ]
        panelLine(198, "Icon size")
        local function resize(d)
            return function()
                iconScale = math.max(0.5, math.min(2, math.floor((iconScale + d) * 100 + 0.5) / 100))
                saveSettings()
                L.sizeZoom, L.settleAt = nil, os.clock()
            end
        end
        button(bx, 202, 44, 26, "+", false, resize(0.05))
        text(bx + 82, 206, math.floor(iconScale * 100 + 0.5) .. "%", C.text, 13, 0.5)
        button(bx + 120, 202, 44, 26, "-", false, resize(-0.05))
        -- Categories
        text(PAD + 2, 240, "Categories", C.muted, 12)

        for i, row in ipairs(rows) do
            local y = listY + (i - 1) * ROW
            if row.cat then
                local k = row.cat
                local on = cats[k].on
                hit(1, y, PW - 2, ROW, C.none, C.hover, function() cats[k].on = not cats[k].on refilter() end, markAll({ k }))
                icon(PAD + 30, y + 4, 20, k, on and 1 or 0.35)
                text(PAD + 56, y + 4, cats[k].title, on and C.text or C.muted, 14, 0, on and 1 or 0.6)
                count(PW - PAD, y + 6, dn[k] or 0, tot[k] or 0)
            else
                local pr = row.parent
                local on = anyOn(pr)
                local d, t = 0, 0
                for _, k in ipairs(pr.children) do d, t = d + (dn[k] or 0), t + (tot[k] or 0) end
                rect(PAD, y, PW - PAD * 2, 1, C.line)
                hit(1, y + 1, PW - 2, ROW - 1, C.none, C.hover, function()
                    local turnOn = not anyOn(pr)
                    for _, k in ipairs(pr.children) do cats[k].on = turnOn end
                    refilter()
                end, markAll(pr.children))
                -- the arrow opens the group's categories under it (one group open at a time)
                hit(1, y + 1, PAD + 22, ROW - 1, C.none, C.hover, function()
                    L.openKey = (L.openKey ~= pr.key) and pr.key or nil
                end, markAll(pr.children))
                text(PAD + 4, y + 5, (L.openKey == pr.key) and "v" or ">", C.muted, 13)
                icon(PAD + 20, y + 3, 22, pr.key, on and 1 or 0.35)
                text(PAD + 48, y + 3, pr.title, on and C.text or C.muted, 15, 0, on and 1 or 0.6)
                count(PW - PAD, y + 6, d, t)
            end
        end
    end
    if not L.collapsed then
        local lines = {
            { "LEFT MENU", C.accent },
            { "Left click a category: show / hide it", C.text },
            { "Right click a category: mark all done / undo", C.text },
            { "> opens the categories of a group", C.text },
            { "ON THE MAP", C.accent },
            { "Point at an icon: its name", C.text },
            { "Left click an icon: mark done / undo", C.text },
            { "Right click stays the game's waypoint", C.muted },
        }
        local hy = height + 8
        local hh = 12 + #lines * 21
        rect(0, hy, PW, hh, C.bg, true)
        frame(0, hy, PW, hh, C.line)
        for i, ln in ipairs(lines) do text(PAD, hy + 7 + (i - 1) * 21, ln[1], ln[2], (ln[2] == C.accent) and 11 or 12) end
    end
    P = nil
    L.panel, L.panelDirty = canvas, false
    L.hoverDirty, L.panelHoverDirty = true, true
end

-- hover highlight of the panel's buttons (only when the mouse is near the panel and has moved)
local function panelHover()
    if not L.hits or not L.panelHoverDirty then return end
    L.panelHoverDirty = false
    local hot = nil
    if not L.mouseX or L.mouseX < 800 then
        for i = #L.hits, 1, -1 do          -- last added is on top
            local h = L.hits[i]
            local ok, v = pcall(hoveredRaw, h.img)
            if ok and v then hot = h break end
        end
    end
    if hot == L.hot then return end
    if L.hot then pcall(function() L.hot.img:SetColorAndOpacity(L.hot.base) end) end
    if hot then pcall(function() hot.img:SetColorAndOpacity(hot.hover) end) end
    L.hot = hot
end

local function clickPanel(right)
    if not (L.panel and L.panel:IsValid() and L.hits) then return false end
    for i = #L.hits, 1, -1 do
        local h = L.hits[i]
        local fn = right and h.rmb or (not right and h.action)
        local ok, v = false, false
        if fn then ok, v = pcall(hoveredRaw, h.img) end
        if ok and v then
            pcall(function() h.img:SetColorAndOpacity(C.press) end)
            L.hot = nil
            fn()
            L.panelDirty, L.flashUntil = true, os.clock() + 0.15
            return true
        end
    end
    -- a click on the panel's background must not mark a marker under it
    local ok, v = pcall(function() return L.panelBg and L.panelBg:IsHovered() end)
    return ok and v == true
end

local function forget(why)
    note("map state dropped: " .. (why or "map widget gone"))
    L.map, L.mapAddr, L.layer, L.items, L.built = nil, nil, nil, {}, 0
    L.hover, L.tip, L.panel, L.hits, L.hot, L.pending, L.panelBg = nil, nil, nil, nil, nil, nil, nil
    L.applyAt, L.settleAt, L.sigMoves, L.scanLeft = nil, nil, nil, 0
    mapList, mapListAt, mapSeen = {}, 0, false
    for k in pairs(textures) do textures[k] = nil end
    crumb(nil)
end

local mapActive = false             -- the map is on screen (set by tick, read by the key callbacks)

local layoutLib = nil
-- mouse position and view centre. When neither them nor the zoom changed since the last pass, the
-- hover scan has nothing new to find and is skipped.
local function viewSignature()
    layoutLib = layoutLib or StaticFindObject("/Script/UMG.Default__WidgetLayoutLibrary")
    local v = layoutLib:GetMousePositionOnViewport(L.map)
    local c = L.map:GetMapPointInViewCenter()
    return v.X, v.Y, c.X, c.Y
end

local function pointerStep()
    local now = os.clock()
    local ok, mx, my, cx, cy = pcall(viewSignature)
    local changed = true
    if ok then
        local moved = mx ~= L.sigMx or my ~= L.sigMy or cx ~= L.sigCx or cy ~= L.sigCy or L.zoom ~= L.sigZ
        L.sigMx, L.sigMy, L.sigCx, L.sigCy, L.sigZ = mx, my, cx, cy, L.zoom
        L.mouseX = mx
        if moved then L.sigMoves = (L.sigMoves or 0) + 1 end
        changed = moved or L.hoverDirty
        -- if the position never changes (not readable on some setup), still look every 2 s
        if not changed and (L.sigMoves or 0) == 0 and now - (L.forcedAt or 0) > 2 then changed = true end
    else
        L.mouseX = nil
    end
    if changed then
        L.forcedAt = now
        L.hoverDirty = false
        L.scanLeft = L.built
        L.panelHoverDirty = true
    end
end

local function tick()
    if os.clock() < pausedUntil or #markers == 0 then mapActive = false return end
    if L.map and not L.map:IsValid() then forget() end
    if L.layer and not L.layer:IsValid() then forget() end
    local map = openMap()
    mapActive = map ~= nil
    if not map then return end
    local addr = addrOf(map)
    if addr == L.mapAddr then L.map = map end   -- same widget, new Lua wrapper
    local needLayer = addr ~= L.mapAddr
    local now = os.clock()
    if not needLayer and now >= (L.attachCheckAt or 0) then
        L.attachCheckAt = now + 1               -- the layer's parent is checked once a second
        needLayer = not attached()
    end
    if needLayer then
        -- new map widget or a rebuilt pin layer (save load): start over
        local ok, err = guarded("new map layer", startLayer, map)
        if not ok then note("layer failed: " .. tostring(err)) L.map = nil return end
    end
    pcall(followZoom)
    if L.built < #markers then buildStep() else resizeStep() end
    if not (L.panel and L.panel:IsValid()) or (L.panelDirty and os.clock() >= (L.flashUntil or 0)) then
        local okp, errp = guarded("panel", buildPanel)
        if not okp and not L.panelErr then L.panelErr = true note("panel failed: " .. tostring(errp)) end
    end
    if L.applyAt then
        crumb("filter update")
        local last = math.min(L.built, L.applyAt + APPLY_PER_TICK - 1)
        for i = L.applyAt, last do if L.items[i] then applyItem(L.items[i]) end end
        L.applyAt = (last < L.built) and last + 1 or nil
        if not L.applyAt then crumb(nil) end
    end
    pcall(pointerStep)
    pcall(panelHover)
    pcall(pendingStep)
    local ok, err = pcall(hoverStep)
    if not ok then countError("hover", err) end
end

-- Hooks and key binds. Every function given to UE4SS goes through pin() and is created once.
-- No hooks on the map widget (1.0.1). The one engine hook is registered here, while the mod loads: a
-- save load restarts the player controller, so the old map state is dropped there.
local onRestart = pin(function() pcall(forget, "player restart (save load)") end)
local okRestart = pcall(RegisterHook, "/Script/Engine.PlayerController:ClientRestart", onRestart)
note("restart hook " .. (okRestart and "on" or "not available"))

-- Level loads (UE4SS built-in): drop the map state before the old world goes
local onLoadMap = pin(function() pcall(forget, "level load") end)
local okMap = pcall(RegisterLoadMapPreHook, onLoadMap)
note("level load hook " .. (okMap and "on" or "not available"))

-- Mouse buttons: the key callback only records the click, and only while the map is on screen (no
-- game calls there); the tick handles it, one click at a time and at most one every 0.2 s, so
-- clicking fast never stacks panel rebuilds.
local clickWanted, clickAt = nil, 0
local onLeft = pin(function() if mapActive then clickWanted = clickWanted or "left" end end)
local okL, lErr = pcall(RegisterKeyBind, Key and Key.LEFT_MOUSE_BUTTON, onLeft)
note("left click " .. (okL and "bound" or ("not bound: " .. tostring(lErr))))
-- right click: only on the panel's categories (mark all); on the map it stays the game's waypoint
local onRight = pin(function() if mapActive then clickWanted = clickWanted or "right" end end)
local okR, rErr = pcall(RegisterKeyBind, Key and Key.RIGHT_MOUSE_BUTTON, onRight)
note("right click " .. (okR and "bound" or ("not bound: " .. tostring(rErr))))

local function clickStep()
    local c = clickWanted
    if not c then return end
    clickWanted = nil
    if os.clock() < clickAt or L.panelDirty or L.applyAt then return end   -- busy: drop it
    clickAt = os.clock() + CLICK_GAP
    if c == "right" then
        local ok, err = guarded("right click", clickPanel, true)
        if not ok then countError("right click", err) end
        return
    end
    local ok, used = guarded("left click", clickPanel)
    if not ok then countError("left click", used) end
    if ok and used then return end
    ok, used = guarded("mark marker", toggleHovered)
    if not ok then countError("mark marker", used) end
end

-- One update step. While the map is closed it does nothing but look at the clock, and it looks for
-- the map only four times a second.
local nextIdle = 0
local function tickAll()
    if not mapActive then
        local now = os.clock()
        if now < nextIdle then return end
        nextIdle = now + 0.25
    end
    tick()
    if mapActive and L.layer and L.map then clickStep() else clickWanted = nil end
end

local slowTicks = 0
local gameTick = pin(function()
    importsThisTick = 0
    local t0 = os.clock()
    local ok, err = pcall(tickAll)
    if not ok then countError("tick", err) end
    local ms = (os.clock() - t0) * 1000
    if ms > 40 and slowTicks < 8 then
        slowTicks = slowTicks + 1
        note(string.format("slow update: %.0f ms (markers built %d)", ms, L.built))
    end
end)

-- The loop runs on the game thread itself (no second thread touching this mod's Lua state, no new
-- function handed to UE4SS every step).
local loopOk, loopHandle = false, nil
if type(LoopInGameThreadWithDelay) == "function" then
    loopOk, loopHandle = pcall(LoopInGameThreadWithDelay, TICK_MS, gameTick)
end
if loopOk then
    pinned.loopHandle = loopHandle
    note("update loop on the game thread, " .. TICK_MS .. " ms")
else
    -- UE4SS without that call: timer thread plus game thread, both functions pinned and created once
    local busy = false
    local onGameThread = pin(function() gameTick() busy = false end)
    local onTimer = pin(function()
        if busy then return false end
        busy = true
        ExecuteInGameThread(onGameThread)
        return false
    end)
    LoopAsync(TICK_MS, onTimer)
    note("update loop on a timer thread, " .. TICK_MS .. " ms")
end
note("ready, open the M map")
