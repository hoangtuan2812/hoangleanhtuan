from __future__ import annotations

import platform
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EVID = ROOT / "evidence" / "S1"
OUT = EVID / "preflight.txt"


def run(cmd):
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        return (result.stdout or result.stderr or "").strip()
    except Exception:
        return ""


EVID.mkdir(parents=True, exist_ok=True)
lines = []
lines.append(f"kien truc CPU: {platform.machine() or 'unknown'}")
lines.append(f"he dieu hanh : {platform.system() or 'unknown'}")
py = platform.python_version()
lines.append(f"phien ban Python: Python {py}")

if shutil.which("docker"):
    docker_version = run(["docker", "--version"])
    lines.append(f"phien ban Docker: {docker_version or 'Docker'}")
    docker_ok = subprocess.run(
        ["docker", "info"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    lines.append("docker daemon: chay" if docker_ok.returncode == 0 else "docker daemon: KHONG CHAY")
else:
    lines.append("phien ban Docker: KHONG CO")
    lines.append("docker daemon: KHONG CHAY")

text = "\n".join(lines) + "\n"
OUT.write_text(text, encoding="utf-8")
print(text, end="")
