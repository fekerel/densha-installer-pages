# Windows EXE Build

Bu klasor, CMD akisini EXE wrapper'a cevirir.

PyInstaller ile iki exe uretilir:

- `Densha-Install.exe`
- `Densha-Start.exe`

Bu EXE'ler arkada yine mevcut script akislarini calistirir:

- `install-densha.cmd` (git clone + npm install + playwright chromium)
- `start-densha.cmd`

## Nasil kullanilir

1. `windows-exe/build-exes.cmd` calistir.
2. Cikan dosyalar `dist/` klasorune yazilir.
3. `dist/` icerigini ZIP yapip dagit.

## Onemli Not

Bu modelde son kullanicida yine `git/node/npm` gerekir.
Sadece giris noktasi `.cmd` yerine `.exe` olur.
