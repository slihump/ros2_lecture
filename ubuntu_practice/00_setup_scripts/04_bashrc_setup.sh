#!/usr/bin/env bash
# 06_터미널_bashrc.pdf 실습 코드
# 06_bashrc_aliases/bashrc_snippet.sh 내용을 ~/.bashrc 끝에 1회 추가한다.
set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SNIPPET="$HERE/06_bashrc_aliases/bashrc_snippet.sh"
MARK="# === ros2_lecture bashrc snippet ==="

if grep -qF "$MARK" ~/.bashrc 2>/dev/null; then
  echo "이미 ~/.bashrc 에 추가되어 있습니다. 건너뜁니다."
  exit 0
fi

{
  echo ""
  echo "$MARK"
  cat "$SNIPPET"
} >> ~/.bashrc

echo "~/.bashrc 에 추가 완료. 적용:  source ~/.bashrc"
echo "이후 새 터미널에서  jazzy  또는  ros2ws  명령으로 환경을 켤 수 있습니다."
