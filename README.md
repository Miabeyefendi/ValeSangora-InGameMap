<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/logo-dark.svg">
  <img src="./assets/logo.svg" width="120" alt="ValeSangora-InGameMap">
</picture>

# ValeSangora-InGameMap

**1799 community markers for The Blood of Dawnwalker, drawn on the game's own map. A UE4SS Lua mod: copy one folder, play.**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-A78BFA?style=for-the-badge&logo=gnu&logoColor=white)](./LICENSE)
[![Version](https://img.shields.io/github/v/release/Miabeyefendi/ValeSangora-InGameMap?style=for-the-badge&color=F59E0B&label=version)](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest)
[![Platform](https://img.shields.io/badge/Windows_%7C_UE4SS-1E293B?style=for-the-badge&logo=windows&logoColor=white)](#-installation)
[![Status](https://img.shields.io/badge/status-active-22C55E?style=for-the-badge)](#)
[![Author](https://img.shields.io/badge/by-Miabeyefendi-0EA5E9?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Miabeyefendi)

**English** · [Türkçe](./README_TR.md) · [Español](./README_ES.md) · [简体中文](./README_ZH.md) · [Русский](./README_RU.md)

[Install](#-installation) · [Features](#-highlights) · [Usage](#-quick-start) · [Tutorial](./TUTORIAL.md) · [Changelog](./CHANGELOG.md)

<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest">
  <img src="./assets/btn-download.svg" height="52" alt="Download the latest release">
</a>
<a href="./TUTORIAL.md">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-tutorial-dark.svg">
    <img src="./assets/btn-tutorial.svg" height="52" alt="Read the tutorial">
  </picture>
</a>

<img src="./design/screenshots/main-showcase.jpg" width="92%" alt="Vale Sangora In-Game Map: the game's map screen full of round category markers, the mod's filter panel on the left, and the lines Filter by category, Click to mark done, Fade or hide finished">

</div>

---

## ✨ Highlights

- **On the game's own map** - press M as usual, the markers are already there, no second window
- **1799 markers, 79 categories** - shrines, camps, vendors, quests, chests, manuals, books, enemies and more
- **Glued to the map** - markers move and zoom with the map, their size matches the game's pins
- **Name on hover** - point at a marker to read its name and category
- **Mark as done** - left click a marker, it fades out; left click again to undo
- **Mark a whole category** - right click a category in the panel, every marker in it is done at once
- **Filter panel** - show or hide any group or category, with a done / total count on each
- **All, Finished or Ongoing** - and finished markers either faded or fully hidden
- **Only Lua, text and PNG files** - nothing to run, nothing to install besides UE4SS
- **Progress is saved** - in a small text file in the mod folder

---

## 📦 Installation

### Requirements

| | |
|---|---|
| Game | The Blood of Dawnwalker (PC) |
| Mod loader | [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS/releases) 3.0.1 or newer, working with the game |
| System | Windows 10 or 11 |

Nothing else. No Node.js, no Python, no .exe or .bat file.

### Built with

![Lua](https://img.shields.io/badge/Lua-1E293B?style=for-the-badge&logo=lua&logoColor=A78BFA)
![UE4SS](https://img.shields.io/badge/UE4SS-1E293B?style=for-the-badge&logo=unrealengine&logoColor=A78BFA)

### Install

1. **Find your game folder.** It is the folder with `Dawnwalker.exe` in it. On Steam: right click the game, **Manage**, **Browse local files**.
2. **Check UE4SS.** Open `Dawnwalker\Binaries\Win64`. If there is a folder named `ue4ss`, UE4SS is installed: go to step 4.
3. **Install UE4SS.** Download `UE4SS_v3.0.1.zip` (not the `zDEV` one) from the [UE4SS releases](https://github.com/UE4SS-RE/RE-UE4SS/releases), open it and copy everything inside into `Dawnwalker\Binaries\Win64`.
4. **Download this mod.** Get `ValeSangoraMap-1.0.0.zip` from the [releases page](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest).
5. **Copy the folder.** Open the zip and copy the `ValeSangoraMap` folder into `Dawnwalker\Binaries\Win64\ue4ss\Mods`.

When it is right, this file exists:

```
Dawnwalker\Binaries\Win64\ue4ss\Mods\ValeSangoraMap\enabled.txt
```

<details>
<summary><b>What is in the release zip</b></summary>

`ValeSangoraMap-1.0.0.zip` is the `src\ValeSangoraMap` folder of this repository, zipped, nothing added: `enabled.txt`, `Scripts\main.lua`, `Data\markers.txt` and 95 PNG icons. No executable file.

SHA-256: `f51329d7c55b0a6e72bbdd123679f0944c160a07246ee09012ba143835c0c780`

</details>

<details>
<summary><b>Install from this repository instead</b></summary>

1. Click **Code**, then **Download ZIP**, or clone the repository:
   ```bash
   git clone https://github.com/Miabeyefendi/ValeSangora-InGameMap.git
   ```
2. Copy the `src\ValeSangoraMap` folder from it into `Dawnwalker\Binaries\Win64\ue4ss\Mods`.

</details>

---

## 🚀 Quick Start

1. Start the game and load a save.
2. Press **M**. The markers appear on the map within a second. The filter panel is on the left.
3. Point at a marker to read its name. Left click it when you have done it.

| Where | Action | Result |
|---|---|---|
| Map | Point at a marker | Its name and category |
| Map | Left click a marker | Marked done, click again to undo |
| Map | Right click | The game's own waypoint, as always |
| Panel | Left click a group or category | Show / hide it |
| Panel | Right click a group or category | Mark all of it done, right click again to undo |
| Panel | `>` | Open the categories of a group |
| Panel | Title bar | Fold the panel |

---

## 🖼️ Screenshots

<table>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-finished-faded.jpg" width="100%" alt="Every marker marked done and drawn faded, the progress bar full and green"/><br/>
    <sub><b>All done, faded</b> · finished markers stay visible but quiet</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-ongoing-only.jpg" width="100%" alt="Only a handful of weapon markers left on the map with the Ongoing filter on"/><br/>
    <sub><b>Ongoing</b> · only what is left to do</sub>
  </td>
</tr>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/panel-close-up.jpg" width="100%" alt="The filter panel: progress bar, Markers, Show, Finished markers and Icon size rows, the category list with counts and the help box"/><br/>
    <sub><b>Filter panel</b> · every group with its done / total count</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-markers.jpg" width="100%" alt="The full map with every category shown and a marker name tooltip on the right"/><br/>
    <sub><b>Everything on</b> · 1799 markers with names on hover</sub>
  </td>
</tr>
</table>

---

## ⚙️ Configuration

Everything is set from the panel on the map screen. The mod keeps it in text files next to itself:

| File | What is in it |
|---|---|
| `ValeSangoraMap\progress.txt` | The markers you marked done. Copy it to back up your progress. |
| `ValeSangoraMap\settings.txt` | Hidden categories, Show mode, Faded / Hidden, icon size |
| `ValeSangoraMap\vsm.log` | What the mod did, for bug reports |
| `ValeSangoraMap\guard.txt` | The step that was running, used by the crash guard |

| Panel row | Choices |
|---|---|
| Markers | Hide all, Show all |
| Show | All, Finished, Ongoing |
| Finished markers | Faded, Hidden (with Show set to All) |
| Icon size | + / - in 5% steps, 50% to 200% |

Every key is explained in the [tutorial](./TUTORIAL.md#️-configuration-reference).

---

## 📖 Documentation

- [**Tutorial**](./TUTORIAL.md) - every feature, every setting, explained in full
- [**Changelog**](./CHANGELOG.md) - what changed in each release
- [**Contributing**](./CONTRIBUTING.md) - how to send a change
- [**Security**](./SECURITY.md) - how to report a vulnerability privately

---

## 🧭 Roadmap

- [ ] Automatic marking from the game: finished places, quests and emptied chests
- [ ] Search box in the panel
- [x] Filter panel, mark a whole category, crash guard

Nothing here is a promise. This is a personal project and the list moves when my
priorities move.

---

## ❓ FAQ

<details>
<summary><b>I press M and see no markers.</b></summary>

Check that `ue4ss\Mods\ValeSangoraMap\enabled.txt` exists (step 5 above). Load a save first, the main menu has no map. If UE4SS itself does not start, the game shows no UE4SS console and no `UE4SS.log` is written in the `ue4ss` folder; fix UE4SS first.

</details>

<details>
<summary><b>Does it change my save?</b></summary>

No. The mod only draws on the map screen. Your progress for the markers lives in `progress.txt` in the mod folder, not in the save.

</details>

<details>
<summary><b>Does it know what I already did in the game?</b></summary>

Not yet. Mark things yourself: left click one marker, or right click a whole category in the panel. Automatic marking is on the roadmap.

</details>

<details>
<summary><b>The game closed. What now?</b></summary>

Start the game again. If the mod was in the middle of something, `vsm.log` starts with a line `previous session ended during: ...` and that session runs in a slower, safer mode. Please open an issue with that line.

</details>

<details>
<summary><b>How do I remove it?</b></summary>

Delete the folder `ue4ss\Mods\ValeSangoraMap`. Keep `progress.txt` somewhere first if you may come back.

</details>

<details>
<summary><b>Is this the same as Vale Sangora Live Map?</b></summary>

No. [Vale Sangora Live Map](https://github.com/Miabeyefendi/vale-sangora-live-map) is a separate map window with live position and automatic marking, and needs Node.js. This mod draws on the game's own map and needs only UE4SS. Their progress files are separate.

</details>

---

## 🤝 Contributing

Contributions are welcome. Read [CONTRIBUTING.md](./CONTRIBUTING.md) and
[CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) first. By contributing you agree to
license your work under the AGPL-3.0.

<div align="center">
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/issues/new?template=bug_report.yml">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-report-bug-dark.svg">
    <img src="./assets/btn-report-bug.svg" height="52" alt="Report a bug">
  </picture>
</a>
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/stargazers">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-star-dark.svg">
    <img src="./assets/btn-star.svg" height="52" alt="Star this repository">
  </picture>
</a>
</div>

---

## 🙏 Credits

- **Marker positions, names and categories** come from the community map of
  [GamerGuides](https://www.gamerguides.com/the-blood-of-dawnwalker/maps/vale-sangora),
  with extra markers from [MapGenie](https://mapgenie.io/the-blood-of-dawnwalker/maps/vale-sangora). The content belongs to them.
  Taken: where things are and what they are called. Added: drawing them inside the game,
  filters, progress and marking.
- **[UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)** by the UE4SS team runs the Lua script inside the game.
- The Blood of Dawnwalker is made by Rebel Wolves. This mod is not affiliated with them.

---

## 🛡️ Security

Found a vulnerability? Do not open a public issue. Follow the private process in
[SECURITY.md](./SECURITY.md).

---

## 📜 License

This project is licensed under the **GNU Affero General Public License v3.0
(AGPL-3.0)**, together with the supplemental terms in the [NOTICE](./NOTICE)
file. In short:

- You may use, study, modify, redistribute and even make money with this software
  for free, **as long as** you keep the complete source code available under the
  AGPL-3.0, including for any hosted, SaaS or network use (AGPL Section 13), and
  you preserve the author attribution below.
- To use this work in a closed-source or proprietary product, or to run it as a
  closed SaaS, you need a **separate written commercial license**, which may
  include a royalty or revenue share. See [NOTICE](./NOTICE), Section 8, and
  contact me.

The marker data in `src\ValeSangoraMap\Data` is third-party content (see Credits) and is
not covered by this license.

### Attribution (required)

Per AGPL-3.0 Section 7(b), the following attribution must be preserved, visibly
and unmodified, in any copy, fork or deployment of this project:

> **Miabeyefendi (Mustafa Ihsan Albayrak)** - https://github.com/Miabeyefendi

### Disclaimer

This software is provided "as is", without warranty of any kind. You run it
entirely at your own risk and are solely responsible for your own use, including
compliance with the terms of service of any third-party platform it interacts
with. Those platforms are not affiliated with or endorsed by the author; their
names and trademarks belong to their respective owners. The author accepts no
liability for account bans, data loss or any other damages, to the maximum extent
permitted by applicable law. Full terms are in the [LICENSE](./LICENSE) and
[NOTICE](./NOTICE) files.

---

## 📬 Contact

- GitHub: [@miabeyefendi](https://github.com/Miabeyefendi)
- For commercial licensing or revenue-sharing enquiries, reach me through my
  GitHub profile.

<div align="center">
<br/>
<img src="./assets/divider.svg" width="100%" height="3" alt="">
<br/>
<sub>Built by <b><a href="https://github.com/Miabeyefendi">Miabeyefendi</a></b></sub>
</div>
