#!/usr/bin/env bash
# 06_터미널_bashrc.pdf 실습 코드
# 06_bashrc_aliases/bashrc_snippet.sh 내용을 ~/.bashrc 에 추가하거나 업데이트한다.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SNIPPET="$HERE/06_bashrc_aliases/bashrc_snippet.sh"
MARK="# === ros2_lecture bashrc snippet ==="
END_MARK="# === end ros2_lecture bashrc snippet ==="
BASHRC="$HOME/.bashrc"
BACKUP="$HOME/.bashrc.ros2_lecture.bak"

touch "$BASHRC"

start_count="$(grep -cFx "$MARK" "$BASHRC" || true)"
end_count="$(grep -cFx "$END_MARK" "$BASHRC" || true)"

if [ "$start_count" -gt 1 ] || [ "$end_count" -gt 1 ]; then
  echo "오류: ~/.bashrc 에 ROS2 관리 marker가 중복되어 있습니다. 직접 확인해 주세요." >&2
  exit 1
fi

if [ "$start_count" -eq 0 ] && [ "$end_count" -ne 0 ]; then
  echo "오류: ~/.bashrc 에 ROS2 끝 marker만 있습니다. 직접 확인해 주세요." >&2
  exit 1
fi

start_line=0
end_line=0
mode="추가"

if [ "$start_count" -eq 1 ]; then
  mode="업데이트"
  start_line="$(grep -nFx "$MARK" "$BASHRC" | cut -d: -f1)"

  if [ "$end_count" -eq 1 ]; then
    end_line="$(grep -nFx "$END_MARK" "$BASHRC" | cut -d: -f1)"
    if [ "$end_line" -le "$start_line" ]; then
      echo "오류: ~/.bashrc 의 ROS2 marker 순서가 올바르지 않습니다." >&2
      exit 1
    fi
  else
    # 이전 버전에는 끝 marker가 없었고, 스니펫의 마지막 줄은 PS1 설정이었다.
    end_line="$(awk -v start="$start_line" 'NR > start && /^PS1=/{print NR; exit}' "$BASHRC")"
    if [ -z "$end_line" ]; then
      echo "오류: 기존 ROS2 블록의 끝을 안전하게 찾지 못했습니다. ~/.bashrc 를 변경하지 않습니다." >&2
      exit 1
    fi
  fi
fi

cp -p "$BASHRC" "$BACKUP"
tmp_file="$(mktemp "$HOME/.bashrc.ros2_lecture.tmp.XXXXXX")"
trap 'rm -f "$tmp_file"' EXIT

{
  if [ "$start_line" -eq 0 ]; then
    cat "$BASHRC"
    printf '\n'
  elif [ "$start_line" -gt 1 ]; then
    sed -n "1,$((start_line - 1))p" "$BASHRC"
  fi

  printf '%s\n' "$MARK"
  cat "$SNIPPET"
  printf '%s\n' "$END_MARK"

  if [ "$end_line" -gt 0 ]; then
    tail -n "+$((end_line + 1))" "$BASHRC"
  fi
} > "$tmp_file"

chmod --reference="$BASHRC" "$tmp_file"
mv "$tmp_file" "$BASHRC"
trap - EXIT

echo "~/.bashrc ROS2 설정 ${mode} 완료. 백업: $BACKUP"
echo "적용:  source ~/.bashrc"
echo "이후 새 터미널에서  jazzy  또는  ros2ws  명령으로 환경을 켤 수 있습니다."
