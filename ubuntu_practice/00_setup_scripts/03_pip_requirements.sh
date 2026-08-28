#!/usr/bin/env bash
# 03강(Jupyter) ~ 25강(주행제어기) 에서 필요한 모든 파이썬 패키지를
# 가상환경(~/venv/ros) 안에 설치한다.
#
# 반드시 가상환경을 먼저 활성화하고 실행:
#   source ~/venv/ros/bin/activate
#   ./03_pip_requirements.sh
set -e

if [ -z "$VIRTUAL_ENV" ]; then
  echo "[중단] 먼저 가상환경을 활성화하세요:  source ~/venv/ros/bin/activate"
  exit 1
fi

python -m pip install --upgrade pip

python -m pip install \
  jupyter \
  ipykernel \
  numpy \
  matplotlib \
  PyQt5 \
  empy \
  catkin_pkg \
  lark \
  lark-parser \
  transforms3d \
  pyyaml \
  setuptools

# Jupyter 에서 이 가상환경을 커널로 쓰기 위해 등록 (08, 09강)
python -m ipykernel install --user --name ros --display-name "ros (venv)"

echo ""
echo "설치 완료. 설치된 주요 패키지:"
python -m pip list | grep -Ei 'jupyter|ipykernel|numpy|matplotlib|PyQt5|empy|catkin|lark|transforms3d' || true
echo ""
echo "메모:"
echo " - empy 4.x 로 메시지 빌드가 실패하면(11강):  python -m pip install 'empy==3.3.4'"
echo " - PyQt5 가 apt 로 필요하면:  sudo apt install -y python3-pyqt5"
