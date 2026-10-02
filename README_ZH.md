<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/logo-dark.svg">
  <img src="./assets/logo.svg" width="120" alt="ValeSangora-InGameMap">
</picture>

# ValeSangora-InGameMap

**为 The Blood of Dawnwalker 准备的 1799 个社区标记，直接画在游戏自己的地图上。UE4SS Lua 模组：复制一个文件夹，开玩。**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-A78BFA?style=for-the-badge&logo=gnu&logoColor=white)](./LICENSE)
[![Version](https://img.shields.io/github/v/release/Miabeyefendi/ValeSangora-InGameMap?style=for-the-badge&color=F59E0B&label=version)](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest)
[![Platform](https://img.shields.io/badge/Windows_%7C_UE4SS-1E293B?style=for-the-badge&logo=windows&logoColor=white)](#-安装)
[![Status](https://img.shields.io/badge/status-active-22C55E?style=for-the-badge)](#)
[![Author](https://img.shields.io/badge/by-Miabeyefendi-0EA5E9?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Miabeyefendi)

[English](./README.md) · [Türkçe](./README_TR.md) · [Español](./README_ES.md) · **简体中文** · [Русский](./README_RU.md)

[安装](#-安装) · [功能](#-亮点) · [用法](#-快速开始) · [更新日志](./CHANGELOG.md)

<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest">
  <img src="./assets/btn-download.svg" height="52" alt="下载最新版本">
</a>
<a href="#-快速开始">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-quick-start-dark.svg">
    <img src="./assets/btn-quick-start.svg" height="52" alt="快速开始">
  </picture>
</a>

<img src="./design/screenshots/main-showcase.jpg" width="92%" alt="游戏的地图界面：Vale Sangora 上分布着数百个圆形分类标记，左侧是模组的筛选面板">

</div>

---

## ✨ 亮点

- **就在游戏自己的地图上** - 照常按 M，标记已经在那里，不需要第二个窗口
- **1799 个标记，79 个分类** - 神龛、营地、商人、任务、宝箱、手册、书籍、敌人等
- **紧贴地图** - 标记随地图一起移动和缩放，大小与游戏自带的图钉一致
- **悬停显示名称** - 鼠标指向标记即可看到名称和分类
- **标记为已完成** - 左键点击标记，它会变淡；再次左键点击即可撤销
- **整类标记** - 在面板中右键点击一个分类，其中所有标记一次完成
- **筛选面板** - 显示或隐藏任意分组或分类，每项都有 已完成 / 总数
- **全部、已完成或进行中** - 已完成的标记可以变淡或完全隐藏
- **只有 Lua、文本和 PNG 文件** - 没有需要运行的程序，除 UE4SS 外无需安装任何东西
- **进度会被保存** - 保存在模组文件夹中的一个小文本文件里

---

## 📦 安装

### 环境要求

| | |
|---|---|
| 游戏 | The Blood of Dawnwalker（PC） |
| 模组加载器 | 能在本游戏中运行的 [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS/releases) 3.0.1 或更高版本 |
| 系统 | Windows 10 或 11 |

不需要其他任何东西。没有 Node.js，没有 Python，没有 .exe 或 .bat 文件。

### 技术栈

![Lua](https://img.shields.io/badge/Lua-1E293B?style=for-the-badge&logo=lua&logoColor=A78BFA)
![UE4SS](https://img.shields.io/badge/UE4SS-1E293B?style=for-the-badge&logo=unrealengine&logoColor=A78BFA)

### 安装步骤

1. **找到游戏文件夹。** 就是包含 `Dawnwalker.exe` 的文件夹。在 Steam 中：右键点击游戏，**管理**，**浏览本地文件**。
2. **检查 UE4SS。** 打开 `Dawnwalker\Binaries\Win64`。如果有名为 `ue4ss` 的文件夹，说明 UE4SS 已安装：跳到第 4 步。
3. **安装 UE4SS。** 从 [UE4SS 发布页](https://github.com/UE4SS-RE/RE-UE4SS/releases) 下载 `UE4SS_v3.0.1.zip`（不是 `zDEV` 开头的那个），打开后把里面的全部内容复制到 `Dawnwalker\Binaries\Win64`。
4. **下载本模组。** 从 [发布页](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest) 下载 `ValeSangoraMap-1.0.0.zip`。
5. **复制文件夹。** 打开 zip，把 `ValeSangoraMap` 文件夹复制到 `Dawnwalker\Binaries\Win64\ue4ss\Mods`。

安装正确时，这个文件存在：

```
Dawnwalker\Binaries\Win64\ue4ss\Mods\ValeSangoraMap\enabled.txt
```

<details>
<summary><b>改为从本仓库安装</b></summary>

1. 点击 **Code**，再点 **Download ZIP**，或者克隆仓库：
   ```bash
   git clone https://github.com/Miabeyefendi/ValeSangora-InGameMap.git
   ```
2. 把其中的 `src\ValeSangoraMap` 文件夹复制到 `Dawnwalker\Binaries\Win64\ue4ss\Mods`。

</details>

---

## 🚀 快速开始

1. 启动游戏并读取存档。
2. 按 **M**。标记在一秒内出现在地图上。筛选面板在左侧。
3. 鼠标指向标记查看名称。完成后左键点击它。

| 位置 | 操作 | 结果 |
|---|---|---|
| 地图 | 指向标记 | 显示名称和分类 |
| 地图 | 左键点击标记 | 标记为已完成，再点一次撤销 |
| 地图 | 右键 | 照常是游戏自己的路径点 |
| 面板 | 左键点击分组或分类 | 显示 / 隐藏 |
| 面板 | 右键点击分组或分类 | 全部标记为已完成，再右键一次撤销 |
| 面板 | `>` | 展开分组下的分类 |
| 面板 | 标题栏 | 折叠面板 |

---

## 🖼️ 截图

<table>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-finished-faded.jpg" width="100%" alt="所有标记都已完成并以淡色显示，进度条已满并为绿色"/><br/>
    <sub><b>全部完成，变淡</b> · 已完成的仍可见但不显眼</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-ongoing-only.jpg" width="100%" alt="开启进行中筛选后，地图上只剩几个武器标记"/><br/>
    <sub><b>进行中</b> · 只显示还没做的</sub>
  </td>
</tr>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/panel-close-up.jpg" width="100%" alt="筛选面板：进度条，Markers、Show、Finished markers 和 Icon size 行，带计数的分类列表和帮助框"/><br/>
    <sub><b>筛选面板</b> · 每个分组都有 已完成 / 总数</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-markers.jpg" width="100%" alt="显示所有分类的完整地图，右侧是一个标记的名称提示"/><br/>
    <sub><b>全部开启</b> · 1799 个标记，悬停显示名称</sub>
  </td>
</tr>
</table>

---

## ⚙️ 配置

所有设置都在地图界面的面板中完成。模组把它们保存在自身旁边的文本文件里：

| 文件 | 内容 |
|---|---|
| `ValeSangoraMap\progress.txt` | 你标记为已完成的标记。复制它即可备份进度。 |
| `ValeSangoraMap\settings.txt` | 隐藏的分类、Show 模式、Faded / Hidden、图标大小 |
| `ValeSangoraMap\vsm.log` | 模组的运行记录，用于报告问题 |
| `ValeSangoraMap\guard.txt` | 当前正在执行的步骤，供崩溃保护使用 |

| 面板行 | 选项 |
|---|---|
| Markers | Hide（全部隐藏）、Show（全部显示） |
| Show | All（全部）、Finished（已完成）、Ongoing（进行中） |
| Finished markers | Faded（变淡）、Hidden（隐藏），在 Show 为 All 时生效 |
| Icon size | + / -，每次 5%，范围 50% 到 200% |

---

## 📖 文档

- [**更新日志**](./CHANGELOG.md) - 每个版本的改动
- [**参与贡献**](./CONTRIBUTING.md) - 如何提交改动
- [**安全**](./SECURITY.md) - 如何私下报告漏洞

---

## 🧭 路线图

- [ ] 从游戏自动标记：已完成的地点、任务和已清空的宝箱
- [ ] 面板中的搜索框
- [x] 筛选面板、整类标记、崩溃保护

这些都不是承诺。这是个人项目，列表会随我的优先级变化。

---

## ❓ 常见问题

<details>
<summary><b>按 M 后看不到标记。</b></summary>

检查 `ue4ss\Mods\ValeSangoraMap\enabled.txt` 是否存在（上面的第 5 步）。请先读取存档，主菜单没有地图。如果 UE4SS 本身没有启动，`ue4ss` 文件夹里不会生成 `UE4SS.log`；请先解决 UE4SS 的问题。

</details>

<details>
<summary><b>会修改我的存档吗？</b></summary>

不会。模组只在地图界面上绘制。标记进度保存在模组文件夹的 `progress.txt` 中，而不是存档里。

</details>

<details>
<summary><b>它知道我在游戏里已经做过什么吗？</b></summary>

暂时不知道。请自己标记：左键点击单个标记，或在面板中右键点击整个分类。自动标记在路线图中。

</details>

<details>
<summary><b>游戏关闭了，怎么办？</b></summary>

重新启动游戏。如果模组当时正在执行某个步骤，`vsm.log` 开头会有一行 `previous session ended during: ...`，该次会话会以更慢、更安全的模式运行。请带上这一行提交 issue。

</details>

<details>
<summary><b>如何卸载？</b></summary>

删除 `ue4ss\Mods\ValeSangoraMap` 文件夹。如果以后可能还会用，先把 `progress.txt` 保存到别处。

</details>

<details>
<summary><b>它和 Vale Sangora Live Map 是同一个东西吗？</b></summary>

不是。[Vale Sangora Live Map](https://github.com/Miabeyefendi/vale-sangora-live-map) 是一个独立的地图窗口，带实时位置和自动标记，需要 Node.js。本模组画在游戏自己的地图上，只需要 UE4SS。两者的进度文件互不相关。

</details>

---

## 🤝 参与贡献

欢迎贡献。请先阅读 [CONTRIBUTING.md](./CONTRIBUTING.md) 和
[CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)。提交贡献即表示你同意以 AGPL-3.0
许可你的成果。

<div align="center">
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/issues/new?template=bug_report.yml">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-report-bug-dark.svg">
    <img src="./assets/btn-report-bug.svg" height="52" alt="报告问题">
  </picture>
</a>
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/stargazers">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-star-dark.svg">
    <img src="./assets/btn-star.svg" height="52" alt="给这个仓库点星">
  </picture>
</a>
</div>

---

## 🙏 致谢

- **标记的位置、名称和分类** 来自 [GamerGuides](https://www.gamerguides.com/the-blood-of-dawnwalker/maps/vale-sangora) 的社区地图，
  额外标记来自 [MapGenie](https://mapgenie.io/the-blood-of-dawnwalker/maps/vale-sangora)。内容归其所有。
  取用的是：东西在哪里、叫什么。新增的是：在游戏内绘制、筛选、进度和标记。
- **[UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)**（UE4SS 团队）在游戏内运行 Lua 脚本。
- The Blood of Dawnwalker 由 Rebel Wolves 开发。本模组与其没有关联。

---

## 🛡️ 安全

发现漏洞了？不要公开提 issue。请按 [SECURITY.md](./SECURITY.md) 中的私密流程
处理。

---

## 📜 许可证

本项目依据 **GNU Affero General Public License v3.0 (AGPL-3.0)** 授权，并附带
[NOTICE](./NOTICE) 文件中的补充条款。简单说：

- 只要你把完整源代码继续以 AGPL-3.0 提供出去（包括任何托管、SaaS 或网络形式的
  使用，见 AGPL 第 13 条），并保留下面的作者署名，你就可以**免费**使用、研究、
  修改、再分发本软件，甚至用它赚钱。
- 若要把本作品用于闭源或专有产品，或作为闭源 SaaS 运行，你需要一份**单独的书面
  商业许可**，其中可能包含分成或版税。见 [NOTICE](./NOTICE) 第 8 节，并与我
  联系。

`src\ValeSangoraMap\Data` 中的标记数据属于第三方内容（见致谢），不受本许可证约束。

### 署名（强制）

根据 AGPL-3.0 第 7(b) 条，以下署名必须在本项目的任何副本、复刻或部署中原样、
可见地保留：

> **Miabeyefendi (Mustafa Ihsan Albayrak)** - https://github.com/Miabeyefendi

### 免责声明

本软件按"原样"提供，不含任何形式的担保。你完全自担风险运行它，并对自己的使用
独自负责，包括遵守它所交互的任何第三方平台的服务条款。这些平台与作者没有关联，
也未为其背书；其名称和商标归各自所有者。在适用法律允许的最大范围内，作者对账号
封禁、数据丢失或任何其他损害不承担责任。完整条款见 [LICENSE](./LICENSE) 与
[NOTICE](./NOTICE) 文件。

---

## 📬 联系方式

- GitHub：[@miabeyefendi](https://github.com/Miabeyefendi)
- 商业授权或分成相关事宜，请通过我的 GitHub 主页联系我。

<div align="center">
<br/>
<img src="./assets/divider.svg" width="100%" height="3" alt="">
<br/>
<sub>由 <b><a href="https://github.com/Miabeyefendi">Miabeyefendi</a></b> 制作</sub>
</div>
