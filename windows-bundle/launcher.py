import ctypes
import os
import subprocess
import sys
import time


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
    oto_dir = os.path.join(apps_dir, "densha-oto")
    ui_exe = os.path.join(apps_dir, "densha-ui.exe")
    node_exe = os.path.join(oto_dir, "node.exe")
    server_js = os.path.join(oto_dir, "server", "automationServer.js")

    missing = []
    if not os.path.isfile(node_exe):
        missing.append(node_exe)
    if not os.path.isfile(server_js):
        missing.append(server_js)
    if not os.path.isfile(ui_exe):
        missing.append(ui_exe)

    if missing:
        show_error("Eksik dosya(lar):\n\n" + "\n".join(missing))
        return 1

    env = os.environ.copy()
    # Point both Playwright instances to the bundled browser directory
    if os.path.isdir(browsers_dir):
        env["PLAYWRIGHT_BROWSERS_PATH"] = browsers_dir

    # Start densha-oto automation server (node.exe server/automationServer.js)
    try:
        subprocess.Popen(
            [node_exe, server_js],
            cwd=oto_dir,
            env=env,
            creationflags=subprocess.CREATE_NEW_PROCESS_GROUP,
        )
    except Exception as exc:
        show_error(f"densha-oto sunucusu baslatılamadı.\n\n{exc}")
        return 1

    # Give the server a moment to bind its port before the UI opens
    time.sleep(1.5)

    # Start densha-ui Electron app
    try:
        subprocess.Popen(
            [ui_exe],
            cwd=root,
            env=env,
            creationflags=subprocess.CREATE_NEW_PROCESS_GROUP,
        )
    except Exception as exc:
        show_error(f"densha-ui baslatilamadı.\n\n{exc}")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
