#!/usr/bin/env bash
# 02_Python_가상환경.pdf 실습 코드
# robot_venv 라는 이름의 파이썬 가상환경을 만든다.
set -e

sudo apt install -y python3.12-venv
pip3 install --upgrade pip --break-system-packages

mkdir -p ~/venv
python3 -m venv ~/venv/robot_venv

echo "가상환경 생성 완료: ~/venv/robot_venv"
echo "활성화하려면: source ~/venv/robot_venv/bin/activate"
echo "종료하려면:   deactivate"
