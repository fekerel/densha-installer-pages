# Densha Installer Pages

Bu repo Densha dagitim sayfasini ve installer scriptlerini tutar.

Bu branch: `feat/exe-no-prereq-distribution`

## Senin istedigin model

Amaç: `.cmd` ile yapilan isi `exe` ile baslatmak.

Davranis ayni kalir:

- `git clone`
- `npm install`
- `npx playwright install chromium`
- `.env` olusturma

Yani EXE burada bir wrapper giristir; kurulum adimlari yine `install-densha.cmd` tarafinda calisir.

## Windows EXE wrapper uretimi

Bu repoda hazir script var:

- `windows-exe/build-exes.cmd`

Urettigi dosyalar:

- `dist/Densha-Install.exe` -> `install-densha.cmd` cagirir
- `dist/Densha-Start.exe` -> `start-densha.cmd` cagirir

### Kullanim

1. `windows-exe/build-exes.cmd` calistir.
2. `dist/` altindaki EXE dosyalarini al.
3. EXE'leri ZIPleyip sayfadan dagit.

## Tek root launcher modeli (hedeflenen dagitim)

Bu modelde zip root'ta tek calistirilabilir dosya olur:

- `Densha-Launcher.exe`

Asagidaki yapi kullanilir:

- `Densha-Launcher.exe`
- `apps/densha-ui.exe`
- `apps/densha-oto.exe`
- `apps/densha-oto-worker.exe`
- `browsers/chromium/chrome-win/chrome.exe`

`Densha-Launcher.exe` hem UI hem OTO exe'lerini birlikte baslatir ve her ikisine de `PLAYWRIGHT_BUNDLED_BROWSER_DIR` ortam degiskenini verir.

Hazirlama scriptleri:

- `windows-bundle/build-all.cmd`
- `windows-bundle/build-launcher.cmd`
- `windows-bundle/prepare-bundle-layout.cmd`

### Zip linkini web sayfasina verme

Buyuk zip dosyasini repoya commit etme. GitHub Release asset olarak yukle:

1. `Densha-Windows-Bundle.zip` dosyasini release'e ekle.
2. Dosya adini sabit tut: `Densha-Windows-Bundle.zip`
3. Sayfada su link kullanilir:

- `https://github.com/fekerel/densha-installer-pages/releases/latest/download/Densha-Windows-Bundle.zip`

## Portable araclar notu

Script kanalinda kullaniciya global kurulum yaptirmadan da calistirabilirsin:

- `tools/node/` altina portable Node koy (icinde `node.exe`, `npm.cmd`, `npx.cmd` olmali)
- `tools/git/` altina portable Git koy (icinde `cmd/git.exe` olmali)

Scriptler once bu portable klasorleri dener, bulamazsa sistemdeki kurulu `git/node/npm`e duser.

Ornek zip duzeni:

- `Densha-Install.exe`
- `Densha-Start.exe`
- `tools/node/...`
- `tools/git/...`

Eger bunlari da kurdurmadan dagitmak istersen, bu artik farkli bir model olur:

- Electron tarafini paketli app/installer yapma
- Oto tarafini binary paketleme
- Runtime'lari paketin icine gommme

Bu adimlar `densha-ui` ve `densha-oto` repolarinda ayrica yapilmali.

## macOS

macOS'ta `.exe` yoktur.
Benzer wrapper mantigi icin `.app`/`.pkg`/`.dmg` gerekir.
Ama mevcut istegin (cmd benzeri akisin wrapper ile acilmasi) Windows odakli EXE ile su an karsilandi.
