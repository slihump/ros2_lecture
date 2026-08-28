#!/usr/bin/env bash
# 03_Jupyter_Notebook.pdf 실습 코드
# robot_venv 안에 Jupyter Notebook을 설치한다. (반드시 venv 활성화 후 실행)
set -e

if [ -z "$VIRTUAL_ENV" ]; then
  echo "먼저 가상환경을 활성화하세요: source ~/venv/robot_venv/bin/activate"
  exit 1
fi

pip install jupyter

echo "설치 완료. 실행하려면 작업 폴더로 이동한 뒤:"
echo "  jupyter notebook"
echo "종료하려면 터미널에서 Ctrl+C"
