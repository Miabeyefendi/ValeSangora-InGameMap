<div align="center">

# 📖 ValeSangora-InGameMap Rehberi

**1.0.0 · Son güncelleme 2026-10-02**

[English](./TUTORIAL.md) · **Türkçe** · [Español](./TUTORIAL_ES.md) · [简体中文](./TUTORIAL_ZH.md) · [Русский](./TUTORIAL_RU.md)

[README'ye dön](./README_TR.md) · [Değişiklikler](./CHANGELOG.md)

</div>

---

Bu belge ValeSangora-InGameMap'in her parçasının ne yaptığını, arka planda nasıl çalıştığını ve
her ayarın gerçekte neyi değiştirdiğini anlatır. Sadece kurup çalıştırmak
istiyorsan [README](./README_TR.md) daha kısa.

## 📑 İçindekiler

- [Genel bakış](#-genel-bakış)
- [Kurulum](#-kurulum)
- [Arayüz turu](#️-arayüz-turu)
- [Özellik referansı](#-özellik-referansı)
- [Yapılandırma referansı](#️-yapılandırma-referansı)
- [Sorun giderme](#-sorun-giderme)
- [Sık sorulanlar](#-sık-sorulanlar)
- [Sözlük](#-sözlük)

---

## 🔭 Genel bakış

### Ne yapar

The Blood of Dawnwalker'ın haritası iyi ama topluluğun bulduğu toplanabilirlerin ve yerlerin
çoğunu göstermiyor. Bu mod o işaretlerden 1799 tanesini (79 kategori, mabetlerden kamplara,
kılavuzlardan kitaplara ve sandıklara kadar) oyunun kendi haritasına, M ile açtığın haritaya çizer.

Bir işaretin üstüne gelip adını okuyabilir, sol tıkla tamamlandı yapabilir, bütün kategorileri
gizleyebilir, bitenleri soluklaştırabilir ya da kaldırabilirsin. Her şey mod klasörüne kaydedilir.

Bu bir UE4SS Lua modudur. Başlatılacak bir program yok, UE4SS dışında kurulacak bir şey yok.

### Nasıl çalışır

1. Oyun modu yüklediğinde mod `Data\markers.txt` (kategoriler ve dünya konumları),
   `progress.txt` ve `settings.txt` dosyalarını okur.
2. Haritayı açtığında haritanın kendi pin kabına tek bir katman ekler ve her işareti oyunun
   kendi dünyadan haritaya dönüşümüyle yerleştirir, kare başına 60 işaret
   (hepsi yaklaşık yarım saniye).
3. Yakınlaştırınca sadece katmanın ölçeği değişir, işaretler haritaya yapışık kalır.
   Yakınlaştırma durunca ikonlar oyunun pinlerine göre yeniden boyutlanır; mod bu pinleri
   haritada ölçer.
4. Farenin altındaki ikonu oyunun arayüz sistemi bildirir. Üzerine gelme ve tıklama doğru
   işareti böyle bulur, ekran hesabı yoktur.
5. Tıklamalar ve filtre değişiklikleri oyun iş parçacığında tek tek işlenir. O an çalışan adım
   `guard.txt` dosyasına yazılır, böylece bir çökme sonraki açılışta izlenebilir.

```
markers.txt ──> harita açılır (M) ──> haritanın pin kabında tek katman
                                       ├─ 1799 ikon, WorldToMapPosition ile yerleşir
                                       ├─ yakınlaştırma: sadece katman ölçeği
                                       └─ üzerine gelme / tık: hangi ikon olduğunu oyun arayüzü söyler
progress.txt <── işarete sol tık, kategoriye sağ tık
settings.txt <── filtre paneli
```

### Dosya düzeni

| Yol | Orada ne var |
|---|---|
| `ValeSangoraMap\enabled.txt` | UE4SS'e modu yüklemesini söyler. Boş dosya. |
| `ValeSangoraMap\Scripts\main.lua` | Modun tamamı |
| `ValeSangoraMap\Data\markers.txt` | Kategoriler ve dünya konumlarıyla 1799 işaret |
| `ValeSangoraMap\Icons\*.png` | Her kategori ve grup için bir ikon |
| `ValeSangoraMap\progress.txt` | Mod yazar: tamamladığın işaretler |
| `ValeSangoraMap\settings.txt` | Mod yazar: paneldeki seçimlerin |
| `ValeSangoraMap\vsm.log` | Mod yazar: olanlar, hata bildirimi için |
| `ValeSangoraMap\guard.txt` | Mod yazar: o an çalışan adım |

Bu depoda mod klasörü `src\ValeSangoraMap` altındadır.

---

## 📦 Kurulum

### Gereksinimler

| Gereksinim | Neden |
|---|---|
| The Blood of Dawnwalker (PC) | Mod onun harita ekranına çizer |
| Oyunla çalışan UE4SS 3.0.1 ya da üstü | Lua modlarını oyuna yükler; o olmadan hiçbir şey çalışmaz |
| Windows 10 ya da 11 | Oyun ve UE4SS Windows'ta çalışır |

### Adım adım

1. Oyun klasörünü bul: Steam'de oyuna sağ tıkla, **Yönet**, **Yerel dosyalara göz at**.
2. `Dawnwalker\Binaries\Win64` klasörünü aç. `ue4ss` klasörü yoksa
   [UE4SS sürümlerinden](https://github.com/UE4SS-RE/RE-UE4SS/releases) `UE4SS_v3.0.1.zip`
   dosyasını indir (`zDEV` değil) ve içindeki her şeyi `Win64` içine kopyala.
3. [Sürümler sayfasından](https://github.com/Miabeyefendi/ValeSangora-InGameMap/releases/latest)
   `ValeSangoraMap-1.0.0.zip` dosyasını indir.
4. Zip içindeki `ValeSangoraMap` klasörünü `Dawnwalker\Binaries\Win64\ue4ss\Mods` içine kopyala.
5. Oyunu başlat, bir kayıt yükle, **M**'ye bas.

### Kurulumu doğrulama

Oyun açıldıktan sonra `ue4ss\Mods\ValeSangoraMap\vsm.log` dosyasını aç. İçinde şunlar olur:

```
loaded 79 categories, 1799 markers
ready, open the M map
```

Haritayı bir kez açınca şu satırlar gelir:

```
layer created at zoom ..., building 1799 markers
all markers built
```

### Güncelleme

Yeni `ValeSangoraMap` klasörünü eskisinin üstüne kopyala ve Windows dosyaları değiştirsin.
`progress.txt` ve `settings.txt` zip içinde yok, ilerlemen ve seçimlerin kalır.

### Kaldırma

`ue4ss\Mods\ValeSangoraMap` klasörünü sil. Mod başka hiçbir yere yazmaz ve kayıt dosyana
asla dokunmaz.

---

## 🖥️ Arayüz turu

<div align="center">
  <img src="./design/screenshots/panel-close-up.jpg" width="92%" alt="Harita ekranının solundaki filtre paneli ve altındaki yardım kutusu"/>
  <br/>
  <sub><b>Filtre paneli</b> · modun yapabildiği her şey, harita ekranında</sub>
</div>

### Filtre paneli

Harita ekranının sol üstünde. Katlamak için başlık çubuğuna tıkla.

| Kontrol | Ne yapar |
|---|---|
| `Progress` | Biten / bütün işaretler, yeşil çubukla |
| `Markers: Hide / Show` | Bütün kategorileri birden gizle ya da göster |
| `Show: All / Finished / Ongoing` | Hepsi, sadece bitenler ya da sadece kalanlar |
| `Finished markers: Faded / Hidden` | Show All iken bitenler soluk ya da hiç çizilmez |
| `Icon size: + / -` | İşaret boyutu, %5 adımla, %50 ile %200 arası |
| Grup satırı, sol tık | Bütün grubu göster ya da gizle |
| Grup satırı, sağ tık | Bütün grubu tamamla, tekrar sağ tık geri al |
| Grup satırında `>` | Kategorilerini altında aç (aynı anda tek grup) |
| Kategori satırı, sol / sağ tık | Grup ile aynı, tek kategori için |
| Sağdaki `d / t` | O satırda biten (yeşil) / toplam (kırmızı), hepsi bitince tamamen yeşil |

### Yardım kutusu

Panelin altında. Fare işlemlerinin kısa listesi, kimse ezberlemek zorunda kalmasın.

### Haritada

| Kontrol | Ne yapar |
|---|---|
| İşaretin üstüne gel | Yanında adı ve kategorisi |
| İşarete sol tık | Tamamlandı, tekrar sol tık geri al |
| Sağ tık | Oyunun kendi yol işareti, değişmedi |
| Sürükle, tekerlek | Haritayı her zamanki gibi kaydır ve yakınlaştır; işaretler takip eder |

---

## 🧩 Özellik referansı

### Oyun haritasında işaretler

**Ne yapar.** M haritasına 1799 topluluk işareti çizer.

**Nasıl çalışır.** Haritanın pin kabına tek katman eklenir. Konumlar oyunun kendi dünyadan
haritaya dönüşümünden gelir, bu yüzden oyunun pinleriyle hizalıdır. Kurulum yaklaşık yarım
saniye sürer (kare başına 60 işaret). Yakınlaştırma sadece katman ölçeğini değiştirir.

**Nasıl kullanılır.** Haritayı aç. Başka bir şey yok.

**Sınırları.** Konumlar topluluk haritasından gelir, birkaçı birkaç metre kayık olabilir.

---

### Üzerine gelince adı

**Ne yapar.** Farenin altındaki işaretin adını ve kategorisini gösterir.

**Nasıl çalışır.** Üzerine gelinen ikonu oyunun arayüz sistemi bildirir. Mod yeni bir işaret
için kare başına 150 ikona, üzerinde durulana her kare bakar.

**Nasıl kullanılır.** Bir işaretin üstüne gel.

**Sınırları.** Gizli işaretlerin adı çıkmaz.

---

### Tamamlandı işareti

**Ne yapar.** Sol tık işareti tamamlandı ile tamamlanmadı arasında değiştirir.

**Nasıl çalışır.** Tık 0,25 saniye bekler. Bu sürede harita kaydıysa ya da yakınlaştıysa bu bir
sürüklemedir, hiçbir şey işaretlenmez. İşaretin numarası `progress.txt` dosyasına yazılır.

**Nasıl kullanılır.** İşarete sol tıkla. Geri almak için tekrar sol tıkla.

**Sınırları.** Mod oyunda ne yaptığını okumaz. İşaretlemeyi sen yaparsın.

---

### Bütün kategoriyi işaretleme

**Ne yapar.** Paneldeki bir gruba ya da kategoriye sağ tık: içindeki her işaret tamamlanır.

**Nasıl çalışır.** İçinde bitmemiş bir şey varsa hepsi tamamlanır. Hepsi zaten bitmişse hepsi
geri alınır.

**Nasıl kullanılır.** Satıra sağ tıkla. Geri almak için tekrar sağ tıkla.

**Sınırları.** Geri alma o satırdaki her işareti temizler, tek tek işaretlediklerin dahil.

---

### Filtreler

**Ne yapar.** Grupları ve kategorileri gösterir ya da gizler; Hepsi, Bitenler ya da Devam
edenler seçilir.

**Nasıl çalışır.** Değişiklikler kare başına 300 ikona uygulanır, 1799 değişiklik bile birkaç
kare sürer. Seçimler `settings.txt` dosyasına kaydedilir.

**Nasıl kullanılır.** Paneldeki satırlara ve butonlara sol tıkla.

**Sınırları.** Henüz arama kutusu yok.

---

### Biten işaretler: soluk ya da gizli

**Ne yapar.** Show All iken biten işaretler %30 opaklıkla (Faded) ya da hiç (Hidden) çizilir.

**Nasıl çalışır.** Hidden, Ongoing gibi çalışır: bitenler çizilmez ve üzerlerine gelinemez.

**Nasıl kullanılır.** Panelde Faded ya da Hidden'a tıkla.

**Sınırları.** Show Finished iken bitenler her zaman tam görünür.

---

### İkon boyutu

**Ne yapar.** İşaretleri büyütür ya da küçültür.

**Nasıl çalışır.** Taban boyut oyunun kendi pinlerinin boyutudur, her yakınlaştırmadan sonra
haritada ölçülür. Paneldeki ayar onu çarpar.

**Nasıl kullanılır.** Icon size satırında + ya da -'ye tıkla.

**Sınırları.** %50 ile %200 arası.

---

### Çökme koruması

**Ne yapar.** Moddaki bir sorunun birikmesini önler ve nerede olduğunu söyler.

**Nasıl çalışır.** Lua hataları yakalanır; 10 saniyede 10 hata modu 30 saniye durdurur. Her
ağır adım adını `guard.txt` dosyasına, bitince `idle` yazar. Oyun bir adımın ortasında
kapandıysa sonraki açılış `previous session ended during: <adım>` yazar ve o oturumu daha
küçük parçalar ve daha yavaş tıklamayla çalıştırır. Kayıt ya da seviye yüklemede mod eski
haritaya ait her referansı, harita yok edilmeden önce bırakır.

**Nasıl kullanılır.** Yapacak bir şey yok. Bir şey ters giderse `vsm.log` dosyasını oku.

**Sınırları.** Oyunun ya da UE4SS'in kendi içindeki bir çökme yakalanamaz, sadece izlenir.

---

## ⚙️ Yapılandırma referansı

Her ayar, ne kabul ettiği ve değiştirince ne olduğu.

### settings.txt

Her satırda bir ayar, anahtar ve değer arasında sekme. Paneli kullanınca mod yazar; elle
yazman gerekmez.

| Anahtar | Tür | Varsayılan | Etkisi |
|---|---|---|---|
| `done` | `all`, `finished`, `ongoing` | `all` | Show satırı |
| `style` | `faded`, `hidden` | `faded` | Finished markers satırı |
| `size` | sayı, `0.50` ile `2.00` arası | `1.00` | Icon size satırı |
| `offcat` | kategori anahtarı | yok | Gizli her kategori için bir satır |

### progress.txt

| Anahtar | Tür | Varsayılan | Etkisi |
|---|---|---|---|
| işaret başına bir satır | işaret numarası | boş | O işaret tamamlanmış sayılır |

### Ayarların tutulduğu yer

İki dosya da mod klasöründe, `ue4ss\Mods\ValeSangoraMap`. Düz metindir. Sadece oyun kapalıyken
düzenle, mod çalışırken onları yazar. İlerlemeni korumak için `progress.txt` dosyasını yedekle.
İkisinde de hesap bilgisi yok.

---

## 🔧 Sorun giderme

### M'ye basıyorum, işaret yok

**Sebep.** Mod yüklenmemiş ya da henüz kayıt yüklenmemiş.
**Çözüm.** `ue4ss\Mods\ValeSangoraMap\enabled.txt` var mı ve `vsm.log` içinde
`ready, open the M map` yazıyor mu bak. Bir kayıt yükle; ana menüde harita yok.

### Hiçbir mod çalışmıyor

**Sebep.** UE4SS çalışmıyor.
**Çözüm.** UE4SS'i yeniden kur (Kurulum, 2. adım). Çalışınca `ue4ss\UE4SS.log` yazılır.

### İşaretler çok büyük ya da çok küçük

**Sebep.** Ekran boyutu ve zevk.
**Çözüm.** Paneldeki Icon size + / - kullan.

### İşarete tıklayınca bir şey olmuyor

**Sebep.** Tık sırasında harita kaydı (sürükleme) ya da tık bir öncekinin hemen ardından geldi.
**Çözüm.** Fareyi oynatmadan tıkla. Tıklar saniyede en fazla beş kez alınır.

### Hata bildirimi için log toplama

`ue4ss\Mods\ValeSangoraMap\vsm.log` dosyasını gönder; oyun kapandıysa bir sonraki açılışın
`vsm.log` ilk satırlarını da. `ue4ss\UE4SS.log` son satırları da işe yarar. Bu dosyalarda hesap
bilgisi yok ama paylaşmadan önce bir göz at.

---

## ❓ Sık sorulanlar

**Kayıt dosyamı değiştirir mi?**
Hayır. Mod sadece harita ekranına çizer. İlerleme `progress.txt` içinde.

**Vale Sangora Live Map ile birlikte kullanabilir miyim?**
Evet. Ayrı çalışırlar, ilerleme dosyaları da ayrıdır.

**Kendi işaretlerimi ekleyebilir miyim?**
`Data\markers.txt` dosyasına aynı biçimde satır ekle (kategori anahtarı, dünya X, dünya Y,
benzersiz bir numara, başlık, aralarında sekme). Güncelleme bu dosyayı değiştirir.

---

## 📕 Sözlük

| Terim | Anlamı |
|---|---|
| UE4SS | Unreal Engine oyunlarında Lua modlarını çalıştıran mod yükleyici |
| İşaret | Bu modun çizdiği tek bir nokta |
| Pin | Oyunun kendi harita ikonlarından biri |
| Grup | Panelde Loot gibi üst satır; kategorileri içerir |
| Kategori | Bir grubun içindeki satır, örneğin Containers |
| Tamamlandı | Senin işaretlediğin |
| Güvenli mod | Oyun bir mod adımı sırasında kapandıktan sonraki, daha küçük adımlı oturum |

---

<div align="center">
<img src="./assets/divider.svg" width="100%" height="3" alt="">
<br/>
<sub><b><a href="https://github.com/Miabeyefendi">Miabeyefendi</a></b> tarafından yapıldı · <a href="./README_TR.md">README'ye dön</a></sub>
</div>
