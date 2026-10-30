<!--
================================================================================
CHANGELOG TEMPLATE - Miabeyefendi (https://github.com/Miabeyefendi)

RULES
  1. Newest release on top. Never rewrite a released entry.
  2. Dates are ISO, YYYY-MM-DD, and are the real publish date.
  3. Versions follow semantic versioning: MAJOR.MINOR.PATCH.
       MAJOR - something that used to work now works differently
       MINOR - new capability, nothing broken
       PATCH - fix only
  4. Only these six group headings, always in this order. Delete the empty ones.
       Added · Changed · Fixed · Removed · Deprecated · Security
  5. Write for the person using the software, not for the person who wrote it.
     "Volume tooltip no longer sticks after a track change" beats
     "refactor volume handler".
  6. Single language. This file stays English, like commit messages.
  7. Link each version number to its release page.
================================================================================
-->

# Changelog

All notable changes to **ValeSangora-InGameMap** are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project uses
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[English](./CHANGELOG.md) · [README](./README.md) · [Tutorial](./TUTORIAL.md)

---

## [1.0.2] - 2026-10-10

### Fixed

- The panel could freeze, with `Ref was not function` in the UE4SS console. UE4SS lost track of the mod's update function after Lua cleaned up its memory. Every function the mod hands to UE4SS is now created once and kept.
- Lag and stutter with several mods installed: while the map is closed the mod now does almost nothing (it no longer searches the whole game for the map every few seconds), and while the map is open it no longer checks every icon when nothing moves.
- Icon files are loaded a few per frame when the map opens, instead of in one go.

### Changed

- The mod's update loop runs on the game thread, so no second thread touches the mod's data.
- The log writes a line when a step is slow (`slow update`, `slow object search`), so lag reports can show where the time went.

---

## [1.0.1] - 2026-10-03

### Fixed

- Panel freezing with `Ref was not function` for some players: the hooks on the map widget are gone (zoom is followed by the update loop), and the update loop runs half as often.

---

## [1.0.0] - 2026-10-02

### Added

- Community map markers drawn on the game's own map (M key): 1799 markers in 79 categories.
- The markers move and zoom together with the game map. Their size follows the game's own map pins.
- Point at a marker to see its name and category.
- Left click a marker to mark it done, left click again to undo.
- Filter panel on the map screen: show or hide every group and every category, done / total count for each.
- Right click a category in the panel to mark all of its markers done at once (right click again to undo).
- Show All, Finished or Ongoing markers. Finished markers can be faded or hidden.
- Icon size setting in the panel.
- Progress, filters and settings are saved in the mod folder and kept between sessions.
- Crash guard: errors pause the mod instead of piling up, and a log line tells which step was running if the game ever closed.

---

<!-- Keep this link block at the bottom and add one line per release. -->

[1.0.2]: https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/tag/v1.0.2
[1.0.1]: https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/tag/v1.0.1
[1.0.0]: https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/tag/v1.0.0
