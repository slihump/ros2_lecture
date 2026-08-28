#!/usr/bin/env bash
# 02_Python_가상환경.pdf 실습 코드
# 파이썬 가상환경을 만든다.
#   - 02강 PDF 에서는 'robot_venv' 라는 이름을 쓰지만,
#     10~25강 화면에서는 실제로 '~/venv/ros' 를 사용한다.
#   - 이 저장소/가이드는 전 과정에서 하나의 이름 '~/venv/ros' 로 통일한다.
set -e

sudo apt update
sudo apt install -y python3.12-venv python3-pip

# 시스템 pip 최신화 (PEP 668 우회)
pip3 install --upgrade pip --break-system-packages || true

mkdir -p ~/venv
python3 -m venv ~/venv/ros

echo ""
echo "가상환경 생성 완료: ~/venv/ros"
echo "활성화: source ~/venv/ros/bin/activate"
echo "종료:   deactivate"
echo ""
echo "다음 단계: 03_pip_requirements.sh (가상환경 활성화 후 실행)"
