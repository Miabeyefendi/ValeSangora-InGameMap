<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./assets/logo-dark.svg">
  <img src="./assets/logo.svg" width="120" alt="ValeSangora-InGameMap">
</picture>

# ValeSangora-InGameMap

**The Blood of Dawnwalker için 1816 topluluk işareti, oyunun kendi haritasında. UE4SS Lua modu: tek klasörü kopyala, oyna.**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-A78BFA?style=for-the-badge&logo=gnu&logoColor=white)](./LICENSE)
[![Version](https://img.shields.io/github/v/release/Miabeyefendi/ValeSangora-InGameMap?style=for-the-badge&color=F59E0B&label=version)](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest)
[![Platform](https://img.shields.io/badge/Windows_%7C_UE4SS-1E293B?style=for-the-badge&logo=windows&logoColor=white)](#-kurulum)
[![Status](https://img.shields.io/badge/status-active-22C55E?style=for-the-badge)](#)
[![Author](https://img.shields.io/badge/by-Miabeyefendi-0EA5E9?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Miabeyefendi)

[English](./README.md) · **Türkçe** · [Español](./README_ES.md) · [简体中文](./README_ZH.md) · [Русский](./README_RU.md)

[Kurulum](#-kurulum) · [Özellikler](#-öne-çıkanlar) · [Kullanım](#-hızlı-başlangıç) · [Rehber](./TUTORIAL_TR.md) · [Değişiklikler](./CHANGELOG.md)

<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest">
  <img src="./assets/btn-download.svg" height="52" alt="Son sürümü indir">
</a>
<a href="./TUTORIAL_TR.md">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-tutorial-dark.svg">
    <img src="./assets/btn-tutorial.svg" height="52" alt="Rehberi oku">
  </picture>
</a>

<img src="./design/screenshots/main-showcase.jpg" width="92%" alt="Vale Sangora In-Game Map: yuvarlak kategori işaretleriyle dolu oyun haritası, solda modun filtre paneli ve altta kategoriye göre filtrele, tıkla tamamla, bitenleri soluklaştır ya da gizle yazıları">

</div>

---

## ✨ Öne çıkanlar

- **Oyunun kendi haritasında** - her zamanki gibi M'ye bas, işaretler zaten orada, ikinci pencere yok
- **1816 işaret, 62 kategori** - mabetler, kamplar, satıcılar, görevler, sandıklar, kılavuzlar, kitaplar, düşmanlar ve dahası
- **Haritaya yapışık** - işaretler haritayla birlikte kayar ve yakınlaşır, boyutları oyunun pinleriyle aynı
- **Üzerine gelince adı** - bir işaretin üstüne gel, adı ve kategorisi çıkar
- **Tamamlandı işareti** - işarete sol tıkla, soluklaşır; tekrar sol tıkla geri al
- **Bütün kategoriyi işaretle** - panelde kategoriye sağ tıkla, içindeki her işaret tek seferde biter
- **Filtre paneli** - her grubu ve kategoriyi göster ya da gizle, her birinde biten / toplam sayısı
- **Hepsi, Bitenler ya da Devam edenler** - bitenler soluk ya da tamamen gizli
- **Sadece Lua, metin ve PNG dosyası** - çalıştırılacak bir şey yok, UE4SS dışında kurulum yok
- **İlerleme kaydedilir** - mod klasöründe küçük bir metin dosyasında

---

## 📦 Kurulum

### Gereksinimler

| | |
|---|---|
| Oyun | The Blood of Dawnwalker (PC) |
| Mod yükleyici | Oyunla çalışan [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS/releases) 3.0.1 ya da üstü |
| Sistem | Windows 10 ya da 11 |

Başka bir şey yok. Node.js yok, Python yok, .exe ya da .bat dosyası yok.

### Kullanılan teknolojiler

![Lua](https://img.shields.io/badge/Lua-1E293B?style=for-the-badge&logo=lua&logoColor=A78BFA)
![UE4SS](https://img.shields.io/badge/UE4SS-1E293B?style=for-the-badge&logo=unrealengine&logoColor=A78BFA)

### Kur

1. **Oyun klasörünü bul.** İçinde `Dawnwalker.exe` olan klasör. Steam'de: oyuna sağ tıkla, **Yönet**, **Yerel dosyalara göz at**.
2. **UE4SS'i kontrol et.** `Dawnwalker\Binaries\Win64` klasörünü aç. `ue4ss` adında bir klasör varsa UE4SS kurulu: 4. adıma geç.
3. **UE4SS'i kur.** [UE4SS sürümlerinden](https://github.com/UE4SS-RE/RE-UE4SS/releases) `UE4SS_v3.0.1.zip` dosyasını indir (`zDEV` olanı değil), aç ve içindeki her şeyi `Dawnwalker\Binaries\Win64` içine kopyala.
4. **Bu modu indir.** [Sürümler sayfasından](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest) `ValeSangoraMap-1.0.3.zip` dosyasını al.
5. **Klasörü kopyala.** Zip'i aç ve `ValeSangoraMap` klasörünü `Dawnwalker\Binaries\Win64\ue4ss\Mods` içine kopyala.

Doğru olduğunda bu dosya vardır:

```
Dawnwalker\Binaries\Win64\ue4ss\Mods\ValeSangoraMap\enabled.txt
```

<details>
<summary><b>Sürüm zip dosyasında ne var</b></summary>

`ValeSangoraMap-1.0.3.zip`, bu deponun `src\ValeSangoraMap` klasörünün zip hali, eklenen bir şey yok: `enabled.txt`, `Scripts\main.lua`, `Data\markers.txt` ve 77 PNG ikon. Çalıştırılabilir dosya yok.

SHA-256: `d0eaca0fa1f305a2a1c67159d0a48d679f6029dd6efb653ebc07c4f2d4792204`

Eski sürümlerin SHA-256 değeri kendi sürüm sayfalarında yazar.

</details>

<details>
<summary><b>Bunun yerine bu depodan kur</b></summary>

1. **Code**, sonra **Download ZIP**'e tıkla ya da depoyu klonla:
   ```bash
   git clone https://github.com/Miabeyefendi/ValeSangora-InGameMap.git
   ```
2. İçindeki `src\ValeSangoraMap` klasörünü `Dawnwalker\Binaries\Win64\ue4ss\Mods` içine kopyala.

</details>

---

## 🚀 Hızlı başlangıç

1. Oyunu başlat ve bir kayıt yükle.
2. **M**'ye bas. İşaretler bir saniye içinde haritada belirir. Filtre paneli solda.
3. Adını görmek için bir işaretin üstüne gel. Yaptığında üstüne sol tıkla.

| Nerede | İşlem | Sonuç |
|---|---|---|
| Harita | İşaretin üstüne gel | Adı ve kategorisi |
| Harita | İşarete sol tıkla | Tamamlandı, tekrar tıkla geri al |
| Harita | Sağ tık | Her zamanki gibi oyunun kendi yol işareti |
| Panel | Gruba ya da kategoriye sol tıkla | Göster / gizle |
| Panel | Gruba ya da kategoriye sağ tıkla | Hepsini tamamla, tekrar sağ tıkla geri al |
| Panel | `>` | Grubun kategorilerini aç |
| Panel | Başlık çubuğu | Paneli katla |

---

## 🖼️ Ekran görüntüleri

<table>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-finished-faded.jpg" width="100%" alt="Bütün işaretler tamamlanmış ve soluk çizilmiş, ilerleme çubuğu dolu ve yeşil"/><br/>
    <sub><b>Hepsi bitti, soluk</b> · bitenler görünür ama sessiz</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-ongoing-only.jpg" width="100%" alt="Devam edenler filtresi açıkken haritada kalan birkaç silah işareti"/><br/>
    <sub><b>Devam edenler</b> · sadece yapılacaklar</sub>
  </td>
</tr>
<tr>
  <td align="center" width="50%">
    <img src="./design/screenshots/panel-close-up.jpg" width="100%" alt="Filtre paneli: ilerleme çubuğu, Markers, Show, Finished markers ve Icon size satırları, sayılı kategori listesi ve yardım kutusu"/><br/>
    <sub><b>Filtre paneli</b> · her grup biten / toplam sayısıyla</sub>
  </td>
  <td align="center" width="50%">
    <img src="./design/screenshots/map-all-markers.jpg" width="100%" alt="Bütün kategoriler açık tam harita, sağda bir işaretin ad kutusu"/><br/>
    <sub><b>Hepsi açık</b> · 1816 işaret, üzerine gelince adı</sub>
  </td>
</tr>
</table>

---

## ⚙️ Yapılandırma

Her şey harita ekranındaki panelden ayarlanır. Mod bunları yanındaki metin dosyalarında tutar:

| Dosya | İçinde ne var |
|---|---|
| `ValeSangoraMap\progress.txt` | Tamamladığın işaretler. İlerlemeni yedeklemek için kopyala. |
| `ValeSangoraMap\settings.txt` | Gizli kategoriler, Show modu, Faded / Hidden, ikon boyutu |
| `ValeSangoraMap\vsm.log` | Modun yaptıkları, hata bildirimi için |
| `ValeSangoraMap\guard.txt` | O an çalışan adım, çökme koruması kullanır |

| Panel satırı | Seçenekler |
|---|---|
| Markers | Hide (hepsini gizle), Show (hepsini göster) |
| Show | All (hepsi), Finished (bitenler), Ongoing (devam edenler) |
| Finished markers | Faded (soluk), Hidden (gizli), Show All iken |
| Icon size | %5 adımla + / -, %50 ile %200 arası |

Her anahtar [rehberde](./TUTORIAL_TR.md#️-yapılandırma-referansı) açıklanıyor.

---

## 📖 Belgeler

- [**Rehber**](./TUTORIAL_TR.md) - her özellik, her ayar, ayrıntısıyla
- [**Değişiklikler**](./CHANGELOG.md) - her sürümde ne değişti
- [**Katkıda bulunma**](./CONTRIBUTING.md) - değişiklik nasıl gönderilir
- [**Güvenlik**](./SECURITY.md) - açık nasıl gizlice bildirilir

---

## 🧭 Yol haritası

- [ ] Oyundan otomatik işaretleme: biten yerler, görevler ve boşaltılan sandıklar
- [ ] Panelde arama kutusu
- [x] Filtre paneli, bütün kategoriyi işaretleme, çökme koruması

Bunların hiçbiri söz değil. Bu kişisel bir proje, öncelikler değiştikçe liste de değişir.

---

## ❓ Sık sorulanlar

<details>
<summary><b>M'ye basıyorum, işaret yok.</b></summary>

`ue4ss\Mods\ValeSangoraMap\enabled.txt` dosyası var mı bak (yukarıdaki 5. adım). Önce bir kayıt yükle, ana menüde harita yok. UE4SS hiç başlamıyorsa `ue4ss` klasöründe `UE4SS.log` oluşmaz; önce UE4SS'i düzelt.

</details>

<details>
<summary><b>Kayıt dosyamı değiştirir mi?</b></summary>

Hayır. Mod sadece harita ekranına çizer. İşaret ilerlemen kayıtta değil, mod klasöründeki `progress.txt` içinde.

</details>

<details>
<summary><b>Oyunda zaten yaptıklarımı biliyor mu?</b></summary>

Henüz değil. Kendin işaretle: tek işarete sol tıkla ya da paneldeki bir kategoriye sağ tıkla. Otomatik işaretleme yol haritasında.

</details>

<details>
<summary><b>Oyun kapandı. Ne yapayım?</b></summary>

Oyunu yeniden başlat. Mod bir işin ortasındaysa `vsm.log` içinde `previous session ended during: ...` satırı olur ve o oturum daha yavaş, daha güvenli modda çalışır. O satırla bir issue aç.

</details>

<details>
<summary><b>Nasıl kaldırırım?</b></summary>

`ue4ss\Mods\ValeSangoraMap` klasörünü sil. Geri dönebilirsen önce `progress.txt` dosyasını bir yere sakla.

</details>

<details>
<summary><b>Vale Sangora Live Map ile aynı şey mi?</b></summary>

Hayır. [Vale Sangora Live Map](https://github.com/Miabeyefendi/vale-sangora-live-map) canlı konum ve otomatik işaretlemeli ayrı bir harita penceresidir ve Node.js ister. Bu mod oyunun kendi haritasına çizer ve sadece UE4SS ister. İlerleme dosyaları ayrıdır.

</details>

---

## 🤝 Katkıda bulunma

Katkılar memnuniyetle karşılanır. Önce [CONTRIBUTING.md](./CONTRIBUTING.md) ve
[CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) dosyalarını oku. Katkıda bulunarak
eserini AGPL-3.0 altında lisanslamayı kabul edersin.

<div align="center">
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/issues/new?template=bug_report.yml">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-report-bug-dark.svg">
    <img src="./assets/btn-report-bug.svg" height="52" alt="Hata bildir">
  </picture>
</a>
<a href="https://github.com/Miabeyefendi/ValeSangora-InGameMap/stargazers">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./assets/btn-star-dark.svg">
    <img src="./assets/btn-star.svg" height="52" alt="Bu depoya yıldız ver">
  </picture>
</a>
</div>

---

## 🙏 Emeği geçenler

- **İşaret konumları, adları ve kategorileri**
  [GamerGuides](https://www.gamerguides.com/the-blood-of-dawnwalker/maps/vale-sangora) topluluk haritasından,
  ek işaretler [MapGenie](https://mapgenie.io/the-blood-of-dawnwalker/maps/vale-sangora) üzerinden gelir. İçerik onlara aittir.
  Alınan: neyin nerede olduğu ve adı. Eklenen: oyunun içinde çizilmesi, filtreler, ilerleme ve işaretleme.
- **[UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)**, UE4SS ekibinin aracı, Lua betiğini oyunun içinde çalıştırır.
- The Blood of Dawnwalker, Rebel Wolves'un oyunudur. Bu modun onlarla bir bağı yoktur.

---

## 🛡️ Güvenlik

Bir zafiyet mi buldun? Halka açık issue açma. [SECURITY.md](./SECURITY.md)
dosyasındaki özel süreci izle.

---

## 📜 Lisans

Bu proje; [NOTICE](./NOTICE) dosyasındaki ek şartlarla birlikte **GNU Affero
General Public License v3.0 (AGPL-3.0)** altında lisanslanmıştır. Kısaca:

- Eksiksiz kaynak kodu AGPL-3.0 altında erişilebilir tuttuğun sürece
  (barındırılan, SaaS veya ağ kullanımı dahil, AGPL Bölüm 13) ve aşağıdaki yazar
  atfını koruduğun sürece bu yazılımı **ücretsiz** kullanabilir, inceleyebilir,
  değiştirebilir, dağıtabilir ve hatta para kazanabilirsin.
- Bu eseri kapalı kaynaklı veya tescilli bir üründe kullanmak ya da kapalı bir
  SaaS olarak çalıştırmak için **ayrı, yazılı bir ticari lisans** gerekir; bu
  lisans royalti veya gelir payı içerebilir. Bkz. [NOTICE](./NOTICE), Bölüm 8;
  benimle iletişime geç.

`src\ValeSangoraMap\Data` içindeki işaret verisi üçüncü taraf içeriğidir (Emeği geçenler bölümüne bak) ve bu lisansın kapsamında değildir.

### Atıf (zorunlu)

AGPL-3.0 Bölüm 7(b) uyarınca aşağıdaki atıf; bu projenin her kopyasında,
fork'unda veya dağıtımında görünür ve değiştirilmeden korunmalıdır:

> **Miabeyefendi (Mustafa İhsan Albayrak)** - https://github.com/Miabeyefendi

### Sorumluluk reddi

Bu yazılım, hiçbir garanti olmaksızın "olduğu gibi" sunulur. Tamamen kendi
riskinle çalıştırırsın ve kendi kullanımından, etkileştiği herhangi bir üçüncü
taraf platformun kullanım koşullarına uymak dahil, yalnızca sen sorumlusun. Bu
platformlar yazarla bağlı veya yazar tarafından onaylanmış değildir; adları ve
ticari markaları ilgili sahiplerine aittir. Yazar; hesap yasakları, veri kaybı
veya başka herhangi bir zarardan, uygulanabilir yasanın izin verdiği azami ölçüde
sorumlu değildir. Tam şartlar [LICENSE](./LICENSE) ve [NOTICE](./NOTICE)
dosyalarındadır.

---

## 📬 İletişim

- GitHub: [@miabeyefendi](https://github.com/Miabeyefendi)
- Ticari lisanslama veya gelir paylaşımı için GitHub profilim üzerinden bana
  ulaş.

<div align="center">
<br/>
<img src="./assets/divider.svg" width="100%" height="3" alt="">
<br/>
<sub><b><a href="https://github.com/Miabeyefendi">Miabeyefendi</a></b> tarafından yapıldı</sub>
</div>
