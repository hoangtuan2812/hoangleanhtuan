# Lab S1. Mục tiêu theo chuẩn chung của học phần.
# Ảnh ghim theo digest. Múi giờ, locale và hạt giống cố định để hai lần chạy cho
# cùng kết quả.

SHELL := cmd.exe
PYTHON ?= python
export TZ := Asia/Ho_Chi_Minh
export LC_ALL := C.UTF-8
export PYTHONHASHSEED := 0

EVID := evidence/S1

.PHONY: preflight up attack defend verify export-evidence down help

help:
	@echo "preflight        ghi thông tin máy, kiểm Docker chạy được"
	@echo "up               dựng môi trường lab"
	@echo "attack           bài S1 không có phần tấn công"
	@echo "defend           bài S1 không có phần phòng thủ bằng cấu hình"
	@echo "verify           chạy bộ kiểm, đây là thứ bộ chấm chạy"
	@echo "export-evidence  gom bằng chứng vào $(EVID)"
	@echo "down             dọn môi trường"

preflight:
	@$(PYTHON) scripts/preflight.py
	@echo
	@echo "Đã ghi $(EVID)/preflight.txt"

up:
	docker compose up --abort-on-container-exit

attack:
	@echo "Bài S1 không có phần tấn công. Xem SCOPE.md."

defend:
	@echo "Bài S1 không có phần phòng thủ bằng cấu hình. Sản phẩm của bài là mô hình đe dọa."

verify:
	$(PYTHON) -m pytest tests/ -v --tb=short

export-evidence:
	@$(PYTHON) -c "from pathlib import Path; import hashlib; import os; root = Path('$(EVID)'); root.mkdir(parents=True, exist_ok=True); import subprocess; subprocess.run(['$(MAKE)', '--no-print-directory', 'preflight'], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL); digest_path = root / 'SHA256SUMS'; lines = []; for p in sorted(root.iterdir()): if p.name == 'SHA256SUMS': continue; h = hashlib.sha256(p.read_bytes()).hexdigest(); lines.append(f'{h}  {p.name}'); digest_path.write_text('\\n'.join(lines) + ('\\n' if lines else ''), encoding='utf-8'); print('Bằng chứng ở ' + str(root) + ', kèm SHA256SUMS.')"

down:
	-docker compose down -v --remove-orphans
