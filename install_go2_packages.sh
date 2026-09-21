#!/usr/bin/env bash
set -euo pipefail

readonly packages=(go2_3d go2_ctrl go2_slam go2_tf)
readonly package_base_url="${GO2_PACKAGE_BASE_URL:-https://raw.githubusercontent.com/slihump/ros2_lecture/main/go2}"
readonly install_root="${GO2_INSTALL_ROOT:-$HOME/ws}"
download_dir=""
stage_dir=""
install_complete=0
installed_packages=()

for command_name in curl unzip; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "[오류] '$command_name' 명령이 필요합니다." >&2
        echo "       sudo apt update && sudo apt install -y curl unzip" >&2
        exit 1
    fi
done

mkdir -p "$install_root"
lock_dir="$install_root/.go2-package-installer.lock"
if ! mkdir "$lock_dir" 2>/dev/null; then
    echo "[오류] 다른 Go2 패키지 설치가 이미 실행 중입니다." >&2
    echo "       실행 중인 설치가 끝난 뒤 다시 시도하세요." >&2
    exit 1
fi

cleanup() {
    if [ "$install_complete" -eq 0 ]; then
        for package in "${installed_packages[@]}"; do
            rm -rf -- "$install_root/$package"
        done
    fi
    [ -z "$download_dir" ] || rm -rf -- "$download_dir"
    [ -z "$stage_dir" ] || rm -rf -- "$stage_dir"
    rmdir "$lock_dir" 2>/dev/null || true
}
trap cleanup EXIT

for package in "${packages[@]}"; do
    if [ -e "$install_root/$package" ] || [ -L "$install_root/$package" ]; then
        echo "[오류] $install_root/$package 폴더가 이미 존재합니다." >&2
        echo "       기존 파일 보호를 위해 아무것도 설치하지 않았습니다." >&2
        exit 1
    fi
done

download_dir="$(mktemp -d)"
stage_dir="$(mktemp -d)"

echo "[Go2] 패키지 다운로드를 시작합니다."
for package in "${packages[@]}"; do
    archive="$download_dir/$package.zip"
    echo "  - $package.zip"
    curl -fL --retry 2 --connect-timeout 10 \
        "$package_base_url/$package.zip" -o "$archive"

    if ! unzip -tq "$archive" >/dev/null; then
        echo "[오류] $package.zip 압축파일 검사 실패" >&2
        exit 1
    fi
done

for package in "${packages[@]}"; do
    unzip -q "$download_dir/$package.zip" -d "$stage_dir"
    if [ ! -d "$stage_dir/$package" ]; then
        echo "[오류] $package.zip 안에 $package 폴더가 없습니다." >&2
        exit 1
    fi
done

find "$stage_dir" -type f \( -name '*.sh' -o -name '*.py' \) -exec chmod +x {} +
for package in "${packages[@]}"; do
    if [ -e "$install_root/$package" ] || [ -L "$install_root/$package" ]; then
        echo "[오류] 설치 중 $install_root/$package 항목이 생성되었습니다." >&2
        echo "       기존 파일 보호를 위해 설치를 중단합니다." >&2
        exit 1
    fi
done
for package in "${packages[@]}"; do
    mv -T --no-clobber "$stage_dir/$package" "$install_root/$package"
    if [ -d "$stage_dir/$package" ]; then
        echo "[오류] 설치 중 $install_root/$package 항목이 생성되었습니다." >&2
        echo "       이번 실행에서 설치한 파일을 되돌립니다." >&2
        exit 1
    fi
    installed_packages+=("$package")
done
install_complete=1

echo
echo "[Go2] 설치 완료: $install_root"
for package in "${packages[@]}"; do
    echo "  - $install_root/$package"
done
echo
echo "다음 단계 예시:"
echo "  python3 $install_root/go2_ctrl/cmd_vel_to_sport.py"
echo "  $install_root/go2_3d/run_slam.sh"
