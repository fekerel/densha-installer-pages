import ctypes
import os
import subprocess
import sys


def show_error(message: str) -> None:
    ctypes.windll.user32.MessageBoxW(0, message, "Densha Launcher", 0x10)


def root_dir() -> str:
    if getattr(sys, "frozen", False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


def main() -> int:
    root = root_dir()
    apps_dir = os.path.join(root, "apps")
    browsers_dir = os.path.join(root, "browsers")

    oto_exe = os.path.join(apps_dir, "densha-oto.exe")
    ui_exe = os.path.join(apps_dir, "densha-ui.exe")

    missing = []
    if not os.path.exists(oto_exe):
        missing.append(oto_exe)
    if not os.path.exists(ui_exe):
        missing.append(ui_exe)

    if missing:
        show_error("Eksik dosya(lar):\n\n" + "\n".join(missing))
        return 1

    env = os.environ.copy()
    if os.path.isdir(browsers_dir):
        env["PLAYWRIGHT_BUNDLED_BROWSER_DIR"] = browsers_dir

    try:
        subprocess.Popen([oto_exe], cwd=root, env=env)
    except Exception as exc:
        show_error(f"densha-oto.exe baslatilamadi.\n\n{exc}")
        return 1

    try:
        subprocess.Popen([ui_exe], cwd=root, env=env)
    except Exception as exc:
        show_error(f"densha-ui.exe baslatilamadi.\n\n{exc}")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
