#!/usr/bin/env bash
# 03_Jupyter_Notebook.pdf 실습 코드 (최소판)
# 가상환경 안에 Jupyter Notebook 만 설치한다.
# 전체 패키지를 한 번에 설치하려면 03_pip_requirements.sh 를 쓰세요.
set -e

if [ -z "$VIRTUAL_ENV" ]; then
  echo "먼저 가상환경을 활성화하세요: source ~/venv/ros/bin/activate"
  exit 1
fi

pip install jupyter

echo "설치 완료. 실행: 작업 폴더로 이동 후  jupyter notebook"
echo "종료: 터미널에서 Ctrl+C"
