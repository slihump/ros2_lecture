#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
installer="$repo_root/install_go2_packages.sh"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

make_fixture() {
    local fixture_dir="$1"
    mkdir -p "$fixture_dir"
    cp "$repo_root"/go2/*.zip "$fixture_dir/"
}

test_installs_all_packages() {
    local test_dir fixture_dir install_root output
    test_dir="$(mktemp -d)"
    trap 'rm -rf "$test_dir"' RETURN
    fixture_dir="$test_dir/downloads"
    install_root="$test_dir/home/ws"
    make_fixture "$fixture_dir"

    output="$(GO2_PACKAGE_BASE_URL="file://$fixture_dir" \
        GO2_INSTALL_ROOT="$install_root" bash "$installer")"

    for package in go2_3d go2_ctrl go2_slam go2_tf; do
        [ -d "$install_root/$package" ] || fail "$package was not installed"
    done
    [ -x "$install_root/go2_3d/run_slam.sh" ] || fail "run_slam.sh is not executable"
    [ -x "$install_root/go2_ctrl/cmd_vel_to_sport.py" ] || fail "Python scripts are not executable"
    [[ "$output" == *"설치 완료"* ]] || fail "success summary was not printed"
}

test_refuses_to_overwrite_existing_package() {
    local test_dir fixture_dir install_root output status
    test_dir="$(mktemp -d)"
    trap 'rm -rf "$test_dir"' RETURN
    fixture_dir="$test_dir/downloads"
    install_root="$test_dir/home/ws"
    make_fixture "$fixture_dir"
    mkdir -p "$install_root/go2_ctrl"
    printf 'keep me\n' > "$install_root/go2_ctrl/user-file.txt"

    set +e
    output="$(GO2_PACKAGE_BASE_URL="file://$fixture_dir" \
        GO2_INSTALL_ROOT="$install_root" bash "$installer" 2>&1)"
    status=$?
    set -e

    [ "$status" -ne 0 ] || fail "installer overwrote an existing package"
    [ "$(cat "$install_root/go2_ctrl/user-file.txt")" = "keep me" ] || fail "existing file changed"
    [ ! -e "$install_root/go2_3d" ] || fail "installer made a partial install"
    [[ "$output" == *"이미 존재"* ]] || fail "overwrite refusal was not explained"
}

test_refuses_dangling_symlink_without_partial_install() {
    local test_dir fixture_dir install_root output status
    test_dir="$(mktemp -d)"
    trap 'rm -rf "$test_dir"' RETURN
    fixture_dir="$test_dir/downloads"
    install_root="$test_dir/home/ws"
    make_fixture "$fixture_dir"
    mkdir -p "$install_root"
    ln -s missing-target "$install_root/go2_ctrl"

    set +e
    output="$(GO2_PACKAGE_BASE_URL="file://$fixture_dir" \
        GO2_INSTALL_ROOT="$install_root" bash "$installer" 2>&1)"
    status=$?
    set -e

    [ "$status" -ne 0 ] || fail "installer accepted a dangling target symlink"
    [ -L "$install_root/go2_ctrl" ] || fail "existing symlink changed"
    [ ! -e "$install_root/go2_3d" ] || fail "installer made a partial install"
    [[ "$output" == *"이미 존재"* ]] || fail "symlink refusal was not explained"
}

test_refuses_concurrent_installer_without_partial_install() {
    local test_dir fixture_dir install_root output status
    test_dir="$(mktemp -d)"
    trap 'rm -rf "$test_dir"' RETURN
    fixture_dir="$test_dir/downloads"
    install_root="$test_dir/home/ws"
    make_fixture "$fixture_dir"
    mkdir -p "$install_root/.go2-package-installer.lock"

    set +e
    output="$(GO2_PACKAGE_BASE_URL="file://$fixture_dir" \
        GO2_INSTALL_ROOT="$install_root" bash "$installer" 2>&1)"
    status=$?
    set -e

    [ "$status" -ne 0 ] || fail "installer ignored an active installation lock"
    [ ! -e "$install_root/go2_3d" ] || fail "concurrent installer made a partial install"
    [[ "$output" == *"이미 실행 중"* ]] || fail "concurrent install refusal was not explained"
}

test_rejects_corrupt_archive_without_partial_install() {
    local test_dir fixture_dir install_root output status
    test_dir="$(mktemp -d)"
    trap 'rm -rf "$test_dir"' RETURN
    fixture_dir="$test_dir/downloads"
    install_root="$test_dir/home/ws"
    make_fixture "$fixture_dir"
    printf 'not a zip\n' > "$fixture_dir/go2_slam.zip"

    set +e
    output="$(GO2_PACKAGE_BASE_URL="file://$fixture_dir" \
        GO2_INSTALL_ROOT="$install_root" bash "$installer" 2>&1)"
    status=$?
    set -e

    [ "$status" -ne 0 ] || fail "installer accepted a corrupt archive"
    [ ! -d "$install_root/go2_3d" ] || fail "installer made a partial install"
    [[ "$output" == *"압축파일 검사 실패"* ]] || fail "corrupt archive was not explained"
}

test_installs_all_packages
test_refuses_to_overwrite_existing_package
test_refuses_dangling_symlink_without_partial_install
test_refuses_concurrent_installer_without_partial_install
test_rejects_corrupt_archive_without_partial_install
echo "Go2 package installer behavior: PASS"
