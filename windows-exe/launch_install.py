import os
import shutil
import subprocess
import sys


def resource_path(filename: str) -> str:
    base_path = getattr(sys, "_MEIPASS", os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_path, filename)


def executable_dir() -> str:
    if getattr(sys, "frozen", False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


def main() -> int:
    embedded_cmd = resource_path("install-densha.cmd")
    if not os.path.exists(embedded_cmd):
        print(f"HATA: Gomme script bulunamadi: {embedded_cmd}")
        input("Devam etmek icin Enter...")
        return 1

    target_dir = executable_dir()
    runner_cmd = os.path.join(target_dir, "__densha_install_runner__.cmd")

    shutil.copyfile(embedded_cmd, runner_cmd)

    try:
        return subprocess.call(["cmd", "/c", runner_cmd], cwd=target_dir)
    finally:
        try:
            os.remove(runner_cmd)
        except OSError:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
