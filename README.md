# Densha Kurulum Scriptleri

Bu klasor iki repo icin tek komutluk kurulum scriptleri icerir:

- `install-densha.ps1`: Windows PowerShell
- `install-densha.sh`: macOS / Linux shell
- `start-densha.ps1`: Windows icin iki projeyi birlikte baslatir
- `start-densha.sh`: macOS icin iki projeyi birlikte baslatir

## Gereksinimler

- Node.js 20+: https://nodejs.org/en/download
- Git: https://git-scm.com/downloads
- Windows icin PowerShell: https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows
- macOS icin Xcode Command Line Tools: https://developer.apple.com/xcode/resources/

Scriptler `git`, `node`, `npm` eksikse erken durur.

Scriptler su adimlari yapar:

1. `densha-oto` reposunu clone eder
2. `densha-ui` reposunu clone eder
3. Her iki proje icin `npm install` calistirir
4. `densha-oto` icin `npx playwright install chromium` calistirir
5. Eksikse `densha-oto/.env` ve `densha-ui/.env` sablonlarini olusturur

## Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\install-densha.ps1
```

Farkli kurulum klasoru icin:

```powershell
powershell -ExecutionPolicy Bypass -File .\install-densha.ps1 -InstallRoot C:\Users\<kullanici>\Desktop\densha
```

## macOS

```bash
chmod +x ./install-densha.sh
./install-densha.sh
```

Farkli kurulum klasoru icin:

```bash
./install-densha.sh "$HOME/Desktop/densha"
```

## Baslatma

Kurulumdan sonra iki projeyi birlikte acmak icin:

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\start-densha.ps1
```

### macOS

```bash
chmod +x ./start-densha.sh
./start-densha.sh
```

Launcher scriptleri su komutlari calistirir:

- `densha-ui`: `npm run start`
- `densha-oto`: `npm run server`

## GitHub Pages Icin Dagitim

`pages/` klasoru publish-ready yapidadir. Bu klasoru ayri bir repo olarak koyup GitHub Pages ile yayinlayabilirsin.

Oneri:

1. `pages/` klasorunu ayri bir repoya koy
2. Repo ayarlarindan GitHub Pages kaynagini `Deploy from a branch` olarak sec
3. Branch olarak `main`, klasor olarak `/root` sec

Notlar:

- Scriptlerin calismasi icin kullanicida `git`, `node`, `npm` kurulu olmali.
- macOS tarafinda ilk calistirmada `xcode-select --install` gerekebilir.
- GitHub Pages scripti direkt calistirmaz; sadece indirilebilir hale getirir.