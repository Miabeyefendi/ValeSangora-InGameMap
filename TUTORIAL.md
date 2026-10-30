<div align="center">

# 📖 ValeSangora-InGameMap Tutorial

**1.0.2 · Last updated 2026-10-30**

**English** · [Türkçe](./TUTORIAL_TR.md) · [Español](./TUTORIAL_ES.md) · [简体中文](./TUTORIAL_ZH.md) · [Русский](./TUTORIAL_RU.md)

[Back to README](./README.md) · [Changelog](./CHANGELOG.md)

</div>

---

This document explains what every part of ValeSangora-InGameMap does, how it works underneath,
and what each setting actually changes. If you only want to install and run it,
the [README](./README.md) is shorter.

## 📑 Contents

- [Overview](#-overview)
- [Installation](#-installation)
- [Interface tour](#️-interface-tour)
- [Feature reference](#-feature-reference)
- [Configuration reference](#️-configuration-reference)
- [Troubleshooting](#-troubleshooting)
- [FAQ](#-faq)
- [Glossary](#-glossary)

---

## 🔭 Overview

### What it does

The Blood of Dawnwalker has a good map, but it does not show most of the collectibles and
places that the community has found. This mod takes 1799 of those markers (79 categories,
from shrines and camps to manuals, books and chests) and draws them on the game's own map,
the one you open with M.

You can point at a marker to read its name, mark it done with a left click, hide whole
categories, and let finished markers fade out or disappear. Everything is saved in the mod
folder.

It is a UE4SS Lua mod. There is no program to start and nothing to install besides UE4SS.

### How it works

1. When the game loads the mod, it reads `Data\markers.txt` (categories and world positions)
   and your `progress.txt` and `settings.txt`.
2. When you open the map, it adds one layer into the map's own pin container and places
   every marker with the game's own world-to-map function, 60 markers per frame
   (about half a second for all of them).
3. When you zoom, only the layer's scale changes, so the markers stay glued to the map.
   After the zoom settles, the icons are resized to match the game's pins, which the mod
   measures on the map.
4. The game's UI system reports which icon is under the mouse. That is how hover and clicks
   find the right marker, with no screen math.
5. Clicks and filter changes are handled one at a time on the game thread. A step that is
   running is written to `guard.txt`, so a crash can be traced on the next start.

```
markers.txt ──> map opens (M) ──> one layer in the map's pin container
                                   ├─ 1799 icons, placed with WorldToMapPosition
                                   ├─ zoom: layer scale only
                                   └─ hover / click: the game UI says which icon
progress.txt <── left click on a marker, right click on a category
settings.txt <── filter panel
```

### File layout

| Path | What lives there |
|---|---|
| `ValeSangoraMap\enabled.txt` | Tells UE4SS to load the mod. Empty file. |
| `ValeSangoraMap\Scripts\main.lua` | The whole mod |
| `ValeSangoraMap\Data\markers.txt` | Categories and the 1799 markers with world positions |
| `ValeSangoraMap\Icons\*.png` | One icon per category and group |
| `ValeSangoraMap\progress.txt` | Written by the mod: your finished markers |
| `ValeSangoraMap\settings.txt` | Written by the mod: your panel choices |
| `ValeSangoraMap\vsm.log` | Written by the mod: what happened, for bug reports |
| `ValeSangoraMap\guard.txt` | Written by the mod: the step that is running |

In this repository the mod folder is `src\ValeSangoraMap`.

---

## 📦 Installation

### Requirements

| Requirement | Why |
|---|---|
| The Blood of Dawnwalker (PC) | The mod draws on its map screen |
| UE4SS 3.0.1 or newer, working with the game | It loads Lua mods into the game; without it nothing runs |
| Windows 10 or 11 | The game and UE4SS run on Windows |

### Step by step

1. Find the game folder: in Steam, right click the game, **Manage**, **Browse local files**.
2. Open `Dawnwalker\Binaries\Win64`. If there is no `ue4ss` folder, download `UE4SS_v3.0.1.zip`
   (not `zDEV`) from the [UE4SS releases](https://github.com/UE4SS-RE/RE-UE4SS/releases) and
   copy everything in it into `Win64`.
3. Download `ValeSangoraMap-1.0.2.zip` from the
   [releases page](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest).
4. Copy the `ValeSangoraMap` folder from the zip into `Dawnwalker\Binaries\Win64\ue4ss\Mods`.
5. Start the game, load a save, press **M**.

### Verifying the install

Open `ue4ss\Mods\ValeSangoraMap\vsm.log` after the game started. It contains:

```
version 1.0.2, loaded 79 categories, 1799 markers
update loop on the game thread, 33 ms
ready, open the M map
```

After you open the map once, these lines follow:

```
layer created at zoom ..., building 1799 markers
all markers built
```

### Updating

Copy the new `ValeSangoraMap` folder over the old one and let Windows replace the files.
`progress.txt` and `settings.txt` are not in the zip, so your progress and choices stay.

### Uninstalling

Delete `ue4ss\Mods\ValeSangoraMap`. The mod writes nothing anywhere else, and it never
touches your save.

---

## 🖥️ Interface tour

<div align="center">
  <img src="./design/screenshots/panel-close-up.jpg" width="92%" alt="The filter panel on the left of the map screen and the help box under it"/>
  <br/>
  <sub><b>Filter panel</b> · everything the mod can do, on the map screen</sub>
</div>

### Filter panel

Top left of the map screen. Click its title bar to fold it.

| Control | What it does |
|---|---|
| `Progress` | Finished / all markers, with a green bar |
| `Markers: Hide / Show` | Hide or show every category at once |
| `Show: All / Finished / Ongoing` | Every marker, only finished ones, or only the ones left |
| `Finished markers: Faded / Hidden` | With Show on All: finished markers faded or not drawn |
| `Icon size: + / -` | Marker size in 5% steps, 50% to 200% |
| Group row, left click | Show or hide the whole group |
| Group row, right click | Mark the whole group done, right click again to undo |
| `>` on a group row | Open its categories under it (one group at a time) |
| Category row, left / right click | Same as a group, for one category |
| `d / t` on the right | Finished (green) / all (red) in that row, all green when complete |

### Help box

Under the panel. A short list of the mouse actions, so nobody has to remember them.

### On the map

| Control | What it does |
|---|---|
| Point at a marker | Its name and category, next to it |
| Left click a marker | Mark done, left click again to undo |
| Right click | The game's own waypoint, unchanged |
| Drag, wheel | Move and zoom the map as always; markers follow |

---

## 🧩 Feature reference

### Markers on the game map

**What it does.** Draws 1799 community markers on the M map.

**How it works.** One layer is added to the map's pin container. Positions come from the
game's own world-to-map function, so they line up with the game's pins. Building takes about
half a second (60 markers per frame). Zoom changes only the layer scale.

**How to use it.** Open the map. Nothing else.

**Limits.** Marker positions come from the community map, a few may be off by some meters.

---

### Name on hover

**What it does.** Shows the name and category of the marker under the mouse.

**How it works.** The game's UI system reports the hovered icon. While the mouse or the map moves,
the mod checks 150 icons per frame until it finds the hovered one. While nothing moves, it
does no work at all.

**How to use it.** Point at a marker.

**Limits.** Hidden markers have no hover.

---

### Mark as done

**What it does.** Left click toggles a marker between done and not done.

**How it works.** The click waits 0.25 seconds. If the map moved or zoomed in that time, it was
a drag and nothing is marked. The marker id goes into `progress.txt`.

**How to use it.** Left click a marker. Left click again to undo.

**Limits.** The mod does not read what you did in the game. You mark things yourself.

---

### Mark a whole category

**What it does.** Right click a group or a category in the panel: every marker in it is done.

**How it works.** If anything in it is not done, all of it becomes done. If all of it is
already done, all of it becomes not done.

**How to use it.** Right click the row. Right click again to undo.

**Limits.** The undo clears every marker in that row, also the ones you marked one by one.

---

### Filters

**What it does.** Shows or hides groups and categories, and chooses All, Finished or Ongoing.

**How it works.** Changes are applied to 300 icons per frame, so even 1799 changes take only a
few frames. Choices are saved in `settings.txt`.

**How to use it.** Left click rows and buttons in the panel.

**Limits.** There is no search box yet.

---

### Finished markers: faded or hidden

**What it does.** With Show on All, finished markers are drawn at 30% opacity (Faded) or not
at all (Hidden).

**How it works.** Hidden works like Ongoing: finished markers are not drawn and have no hover.

**How to use it.** Click Faded or Hidden in the panel.

**Limits.** With Show on Finished, finished markers are always fully visible.

---

### Icon size

**What it does.** Makes the markers bigger or smaller.

**How it works.** The base size is the size of the game's own pins, measured on the map after
every zoom. The panel setting multiplies it.

**How to use it.** Click + or - in the Icon size row.

**Limits.** 50% to 200%.

---

### Crash guard

**What it does.** Keeps a problem in the mod from piling up, and tells you where it was.

**How it works.** Lua errors are caught; 10 errors in 10 seconds pause the mod for 30 seconds.
Every heavy step writes its name to `guard.txt` and `idle` when it ends. If the game closed in
the middle of a step, the next start logs `previous session ended during: <step>` and runs
that session with smaller batches and slower clicks. On a save or level load the mod drops
every reference to the old map before it is destroyed.

**How to use it.** Nothing to do. Read `vsm.log` if something went wrong.

**Limits.** A crash inside the game or UE4SS itself cannot be caught, only traced.

---

## ⚙️ Configuration reference

Every setting, what it accepts, and what happens when you change it.

### settings.txt

One setting per line, key and value separated by a tab. The panel writes it; you never have to.

| Key | Type | Default | Effect |
|---|---|---|---|
| `done` | `all`, `finished`, `ongoing` | `all` | The Show row |
| `style` | `faded`, `hidden` | `faded` | The Finished markers row |
| `size` | number, `0.50` to `2.00` | `1.00` | The Icon size row |
| `offcat` | category key | none | One line per hidden category |

### progress.txt

| Key | Type | Default | Effect |
|---|---|---|---|
| one line per marker | marker id (number) | empty | That marker counts as done |

### Where the settings are stored

Both files are in the mod folder, `ue4ss\Mods\ValeSangoraMap`. They are plain text. Edit them
only while the game is closed, the mod writes them while it runs. Back up `progress.txt` to
keep your progress. Neither file holds any account data.

---

## 🔧 Troubleshooting

### I press M and see no markers

**Cause.** The mod is not loaded, or no save is loaded yet.
**Fix.** Check that `ue4ss\Mods\ValeSangoraMap\enabled.txt` exists and that `vsm.log` says
`ready, open the M map`. Load a save; the main menu has no map.

### No mod works at all

**Cause.** UE4SS is not running.
**Fix.** Install UE4SS again (Installation, step 2). When it runs, `ue4ss\UE4SS.log` is written.

### Markers are too big or too small

**Cause.** Screen size and taste.
**Fix.** Use Icon size + / - in the panel.

### Clicking a marker does nothing

**Cause.** The map moved during the click (a drag), or the click came right after another one.
**Fix.** Click without moving the mouse. Clicks are taken at most five times a second.

### Collecting a log for a bug report

Send `ue4ss\Mods\ValeSangoraMap\vsm.log` and, if the game closed, the first lines of the next
start's `vsm.log`. Also useful: the last lines of `ue4ss\UE4SS.log`. These files hold no
account data, but check them before you post.

---

## ❓ FAQ

**Does it change my save?**
No. The mod only draws on the map screen. Progress is in `progress.txt`.

**Can I use it with Vale Sangora Live Map?**
Yes. They are separate, and their progress files are separate too.

**Can I add my own markers?**
Add lines to `Data\markers.txt` in the same format (category key, world X, world Y, a unique
number, title, separated by tabs). An update replaces this file.

---

## 📕 Glossary

| Term | Meaning |
|---|---|
| UE4SS | The mod loader that runs Lua mods inside Unreal Engine games |
| Marker | One point drawn by this mod |
| Pin | One of the game's own map icons |
| Group | A top row in the panel, such as Loot; it holds categories |
| Category | A row inside a group, such as Containers |
| Finished | Marked done by you |
| Safe mode | One session with smaller steps, after the game closed during a mod step |

---

<div align="center">
<img src="./assets/divider.svg" width="100%" height="3" alt="">
<br/>
<sub>Built by <b><a href="https://github.com/Miabeyefendi">Miabeyefendi</a></b> · <a href="./README.md">Back to README</a></sub>
</div>
