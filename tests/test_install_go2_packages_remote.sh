#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

GO2_INSTALL_ROOT="$test_dir/ws" bash "$repo_root/install_go2_packages.sh" >/dev/null

for package in go2_3d go2_ctrl go2_slam go2_tf; do
    if [ ! -d "$test_dir/ws/$package" ]; then
        echo "FAIL: GitHub에서 $package 패키지를 설치하지 못했습니다." >&2
        exit 1
    fi
done

test -x "$test_dir/ws/go2_3d/run_slam.sh"
test -x "$test_dir/ws/go2_ctrl/cmd_vel_to_sport.py"
echo "Go2 package GitHub download: PASS"
