<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/logo-dark.svg">
  <img src="./assets/logo.svg" width="120" alt="ValeSangora-InGameMap">
</picture>

# ValeSangora-InGameMap

**1799 меток сообщества для The Blood of Dawnwalker прямо на карте самой игры. Lua-мод для UE4SS: скопируйте одну папку и играйте.**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-A78BFA?style=for-the-badge&logo=gnu&logoColor=white)](./LICENSE)
[![Version](https://img.shields.io/github/v/release/Miabeyefendi/ValeSangora-InGameMap?style=for-the-badge&color=F59E0B&label=version)](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest)
[![Platform](https://img.shields.io/badge/Windows_%7C_UE4SS-1E293B?style=for-the-badge&logo=windows&logoColor=white)](#-установка)
[![Status](https://img.shields.io/badge/status-active-22C55E?style=for-the-badge)](#)
[![Author](https://img.shields.io/badge/by-Miabeyefendi-0EA5E9?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Miabeyefendi)

[English](./README.md) · [Türkçe](./README_TR.md) · [Español](./README_ES.md) · [简体中文](./README_ZH.md) · **Русский**

[Установка](#-установка) · [Возможности](#-главное) · [Использование](#-быстрый-старт) · [Руководство](./TUTORIAL_RU.md) · [Изменения](./CHANGELOG.md)

<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest">
  <img src="./assets/btn-download.svg" height="52" alt="Скачать последнюю версию">
</a>
<a href="./TUTORIAL_RU.md">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-tutorial-dark.svg">
    <img src="./assets/btn-tutorial.svg" height="52" alt="Читать руководство">
  </picture>
</a>

<img src="./design/screenshots/main-showcase.jpg" width="92%" alt="Vale Sangora In-Game Map: экран карты игры с множеством круглых меток категорий, панель фильтров мода слева и подписи фильтр по категориям, клик для отметки, бледные или скрытые выполненные">

</div>

---

## ✨ Главное

- **На карте самой игры** - нажмите M как обычно, метки уже там, второго окна нет
- **1799 меток, 79 категорий** - святилища, лагеря, торговцы, задания, сундуки, руководства, книги, враги и другое
- **Привязаны к карте** - метки двигаются и масштабируются вместе с картой, их размер совпадает с метками игры
- **Название при наведении** - наведите курсор на метку, чтобы увидеть название и категорию
- **Отметить выполненным** - левый клик по метке, она становится бледной; повторный левый клик отменяет
- **Отметить всю категорию** - правый клик по категории в панели, и все её метки выполнены сразу
- **Панель фильтров** - показ и скрытие любой группы или категории, у каждой счётчик выполнено / всего
- **Все, Выполненные или Оставшиеся** - а выполненные бледные или скрыты полностью
- **Только файлы Lua, текст и PNG** - нечего запускать, ничего не нужно ставить, кроме UE4SS
- **Прогресс сохраняется** - в маленьком текстовом файле в папке мода

---

## 📦 Установка

### Требования

| | |
|---|---|
| Игра | The Blood of Dawnwalker (PC) |
| Загрузчик модов | [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS/releases) 3.0.1 или новее, работающий с игрой |
| Система | Windows 10 или 11 |

Больше ничего. Без Node.js, без Python, без файлов .exe и .bat.

### На чём собрано

![Lua](https://img.shields.io/badge/Lua-1E293B?style=for-the-badge&logo=lua&logoColor=A78BFA)
![UE4SS](https://img.shields.io/badge/UE4SS-1E293B?style=for-the-badge&logo=unrealengine&logoColor=A78BFA)

### Установить

1. **Найдите папку игры.** Это папка, в которой лежит `Dawnwalker.exe`. В Steam: правый клик по игре, **Управление**, **Просмотреть локальные файлы**.
2. **Проверьте UE4SS.** Откройте `Dawnwalker\Binaries\Win64`. Если там есть папка `ue4ss`, UE4SS установлен: переходите к шагу 4.
3. **Установите UE4SS.** Скачайте `UE4SS_v3.0.1.zip` (не тот, что начинается с `zDEV`) со [страницы релизов UE4SS](https://github.com/UE4SS-RE/RE-UE4SS/releases), откройте и скопируйте всё содержимое в `Dawnwalker\Binaries\Win64`.
4. **Скачайте этот мод.** Возьмите `ValeSangoraMap-1.0.0.zip` на [странице релизов](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest).
5. **Скопируйте папку.** Откройте zip и скопируйте папку `ValeSangoraMap` в `Dawnwalker\Binaries\Win64\ue4ss\Mods`.

Если всё верно, этот файл существует:

```
Dawnwalker\Binaries\Win64\ue4ss\Mods\ValeSangoraMap\enabled.txt
```

<details>
<summary><b>Что внутри zip релиза</b></summary>

`ValeSangoraMap-1.0.0.zip` это папка `src\ValeSangoraMap` этого репозитория в zip, без добавлений: `enabled.txt`, `Scripts\main.lua`, `Data\markers.txt` и 95 значков PNG. Исполняемых файлов нет.

SHA-256: `f51329d7c55b0a6e72bbdd123679f0944c160a07246ee09012ba143835c0c780`

</details>

<details>
<summary><b>Установка из этого репозитория</b></summary>

1. Нажмите **Code**, затем **Download ZIP**, или клонируйте репозиторий:
   ```bash
   git clone https://github.com/Miabeyefendi/ValeSangora-InGameMap.git
   ```
2. Скопируйте папку `src\ValeSangoraMap` в `Dawnwalker\Binaries\Win64\ue4ss\Mods`.

</details>

---

## 🚀 Быстрый старт

1. Запустите игру и загрузите сохранение.
2. Нажмите **M**. Метки появятся на карте за секунду. Панель фильтров слева.
3. Наведите курсор на метку, чтобы прочитать название. Когда выполните, кликните по ней левой кнопкой.

| Где | Действие | Результат |
|---|---|---|
| Карта | Навести на метку | Название и категория |
| Карта | Левый клик по метке | Отмечено выполненным, повторный клик отменяет |
| Карта | Правый клик | Путевая точка самой игры, как обычно |
| Панель | Левый клик по группе или категории | Показать / скрыть |
| Панель | Правый клик по группе или категории | Отметить всё выполненным, повторный правый клик отменяет |
| Панель | `>` | Открыть категории группы |
| Панель | Заголовок | Свернуть панель |

---

## 🖼️ Скриншоты

<table>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-finished-faded.jpg" width="100%" alt="Все метки отмечены выполненными и нарисованы бледными, полоса прогресса заполнена и зелёная"/><br/>
    <sub><b>Всё выполнено, бледно</b> · выполненное видно, но не мешает</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-ongoing-only.jpg" width="100%" alt="С фильтром Оставшиеся на карте осталось лишь несколько меток оружия"/><br/>
    <sub><b>Оставшиеся</b> · только то, что ещё не сделано</sub>
  </td>
</tr>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/panel-close-up.jpg" width="100%" alt="Панель фильтров: полоса прогресса, строки Markers, Show, Finished markers и Icon size, список категорий со счётчиками и блок подсказок"/><br/>
    <sub><b>Панель фильтров</b> · у каждой группы счётчик выполнено / всего</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-markers.jpg" width="100%" alt="Вся карта со всеми категориями и подсказкой с названием метки справа"/><br/>
    <sub><b>Всё включено</b> · 1799 меток с названием при наведении</sub>
  </td>
</tr>
</table>

---

## ⚙️ Настройка

Всё настраивается в панели на экране карты. Мод хранит это в текстовых файлах рядом с собой:

| Файл | Что внутри |
|---|---|
| `ValeSangoraMap\progress.txt` | Метки, которые вы отметили выполненными. Скопируйте его для резервной копии прогресса. |
| `ValeSangoraMap\settings.txt` | Скрытые категории, режим Show, Faded / Hidden, размер значков |
| `ValeSangoraMap\vsm.log` | Что делал мод, для сообщений об ошибках |
| `ValeSangoraMap\guard.txt` | Текущий шаг, используется защитой от вылетов |

| Строка панели | Варианты |
|---|---|
| Markers | Hide (скрыть все), Show (показать все) |
| Show | All (все), Finished (выполненные), Ongoing (оставшиеся) |
| Finished markers | Faded (бледные), Hidden (скрытые), при Show = All |
| Icon size | + / - с шагом 5%, от 50% до 200% |

Каждый ключ описан в [руководстве](./TUTORIAL_RU.md#️-справочник-настроек).

---

## 📖 Документация

- [**Руководство**](./TUTORIAL_RU.md) - каждая возможность и каждая настройка подробно
- [**Изменения**](./CHANGELOG.md) - что изменилось в каждой версии
- [**Участие**](./CONTRIBUTING.md) - как отправить изменение
- [**Безопасность**](./SECURITY.md) - как сообщить об уязвимости приватно

---

## 🧭 Планы

- [ ] Автоматическая отметка из игры: пройденные места, задания и опустошённые сундуки
- [ ] Поле поиска в панели
- [x] Панель фильтров, отметка всей категории, защита от вылетов

Это не обещания. Это личный проект, и список меняется вместе с моими приоритетами.

---

## ❓ Частые вопросы

<details>
<summary><b>Нажимаю M, а меток нет.</b></summary>

Проверьте, что существует `ue4ss\Mods\ValeSangoraMap\enabled.txt` (шаг 5). Сначала загрузите сохранение, в главном меню карты нет. Если UE4SS вообще не запускается, в папке `ue4ss` не появляется `UE4SS.log`; сначала исправьте UE4SS.

</details>

<details>
<summary><b>Мод меняет моё сохранение?</b></summary>

Нет. Мод только рисует на экране карты. Прогресс по меткам хранится в `progress.txt` в папке мода, а не в сохранении.

</details>

<details>
<summary><b>Он знает, что я уже сделал в игре?</b></summary>

Пока нет. Отмечайте сами: левый клик по одной метке или правый клик по целой категории в панели. Автоматическая отметка есть в планах.

</details>

<details>
<summary><b>Игра закрылась. Что делать?</b></summary>

Запустите игру снова. Если мод был в середине какого-то шага, `vsm.log` начнётся со строки `previous session ended during: ...`, и эта сессия пойдёт в более медленном и безопасном режиме. Откройте issue с этой строкой.

</details>

<details>
<summary><b>Как удалить?</b></summary>

Удалите папку `ue4ss\Mods\ValeSangoraMap`. Если, возможно, вернётесь, сначала сохраните `progress.txt` в другом месте.

</details>

<details>
<summary><b>Это то же самое, что Vale Sangora Live Map?</b></summary>

Нет. [Vale Sangora Live Map](https://github.com/Miabeyefendi/vale-sangora-live-map) это отдельное окно карты с позицией в реальном времени и автоматической отметкой, ему нужен Node.js. Этот мод рисует на карте самой игры, и ему нужен только UE4SS. Их файлы прогресса не связаны.

</details>

---

## 🤝 Участие

Вклад приветствуется. Сначала прочитайте [CONTRIBUTING.md](./CONTRIBUTING.md) и
[CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md). Внося вклад, вы соглашаетесь
лицензировать свою работу под AGPL-3.0.

<div align="center">
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/issues/new?template=bug_report.yml">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-report-bug-dark.svg">
    <img src="./assets/btn-report-bug.svg" height="52" alt="Сообщить об ошибке">
  </picture>
</a>
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/stargazers">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-star-dark.svg">
    <img src="./assets/btn-star.svg" height="52" alt="Поставить звезду репозиторию">
  </picture>
</a>
</div>

---

## 🙏 Благодарности

- **Положения, названия и категории меток** взяты с карты сообщества
  [GamerGuides](https://www.gamerguides.com/the-blood-of-dawnwalker/maps/vale-sangora),
  дополнительные метки с [MapGenie](https://mapgenie.io/the-blood-of-dawnwalker/maps/vale-sangora). Контент принадлежит им.
  Взято: где что находится и как называется. Добавлено: отрисовка внутри игры, фильтры, прогресс и отметки.
- **[UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)** от команды UE4SS запускает Lua-скрипт внутри игры.
- The Blood of Dawnwalker создана Rebel Wolves. Этот мод с ними не связан.

---

## 🛡️ Безопасность

Нашли уязвимость? Не открывайте публичный issue. Следуйте приватной процедуре из
[SECURITY.md](./SECURITY.md).

---

## 📜 Лицензия

Проект распространяется под **GNU Affero General Public License v3.0
(AGPL-3.0)** вместе с дополнительными условиями из файла [NOTICE](./NOTICE).
Коротко:

- Вы можете бесплатно использовать, изучать, изменять, распространять и даже
  зарабатывать на этой работе, **при условии** что вы сохраняете полный исходный
  код доступным под AGPL-3.0, включая любое размещённое, SaaS или сетевое
  использование (AGPL, раздел 13), и сохраняете указанную ниже атрибуцию автора.
- Для использования в закрытом или проприетарном продукте, а также для запуска в
  виде закрытого SaaS требуется **отдельная письменная коммерческая лицензия**,
  которая может включать роялти или долю дохода. См. [NOTICE](./NOTICE),
  раздел 8, и свяжитесь со мной.

Данные меток в `src\ValeSangoraMap\Data` являются сторонним контентом (см. Благодарности) и не подпадают под эту лицензию.

### Атрибуция (обязательна)

Согласно разделу 7(b) AGPL-3.0, следующая атрибуция должна сохраняться на
видном месте и без изменений в любой копии, форке или развёртывании проекта:

> **Miabeyefendi (Mustafa Ihsan Albayrak)** - https://github.com/Miabeyefendi

### Отказ от ответственности

Программа предоставляется «как есть», без каких-либо гарантий. Вы запускаете её
целиком на свой страх и риск и несёте единоличную ответственность за собственное
использование, включая соблюдение условий обслуживания любой сторонней
платформы, с которой она взаимодействует. Эти платформы не связаны с автором и
не одобряют его работу; их названия и товарные знаки принадлежат их владельцам.
Автор не несёт ответственности за блокировки аккаунтов, потерю данных и любой
другой ущерб в максимальной степени, допустимой применимым правом. Полные
условия в файлах [LICENSE](./LICENSE) и [NOTICE](./NOTICE).

---

## 📬 Контакты

- GitHub: [@miabeyefendi](https://github.com/Miabeyefendi)
- По вопросам коммерческого лицензирования или разделения дохода пишите через мой
  профиль GitHub.

<div align="center">
<br/>
<img src="./assets/divider.svg" width="100%" height="3" alt="">
<br/>
<sub>Сделано <b><a href="https://github.com/Miabeyefendi">Miabeyefendi</a></b></sub>
</div>
