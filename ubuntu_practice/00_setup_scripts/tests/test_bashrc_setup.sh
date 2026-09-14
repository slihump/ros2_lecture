#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_HOME="$(mktemp -d /tmp/ros2-bashrc-test.XXXXXX)"
trap 'rm -rf "$TEST_HOME"' EXIT

touch "$TEST_HOME/.bashrc"
HOME="$TEST_HOME" "$SETUP_DIR/04_bashrc_setup.sh" >/dev/null

EXPECTED_PS1='${ROS_DOMAIN_ID:+\[\e[1;34m\](ID:${ROS_DOMAIN_ID})\[\e[0m\] }\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ ' \
HOME="$TEST_HOME" env -u ROS_DOMAIN_ID -u ROS_VERSION \
  bash --noprofile --norc -c '
    set -eo pipefail
    fail() { echo "FAIL: $*" >&2; exit 1; }
    source "$HOME/.bashrc"

    test -z "${ROS_DOMAIN_ID+x}" || fail "ROS_DOMAIN_ID must stay unset until jazzy or ros2ws is run"
    test -z "${ROS_VERSION+x}" || fail "ROS2 must not be sourced automatically at shell startup"

    ros_domain_def="$(alias ros_domain)"
    venv_ros_def="$(alias venv_ros)"
    jazzy_def="$(alias jazzy)"
    ros2ws_def="$(alias ros2ws)"

    [[ "$ros_domain_def" == *"export ROS_DOMAIN_ID=98"* ]] || fail "ros_domain must set domain ID 98"
    [[ "$venv_ros_def" == *"source \"\$ROS2_VENV/bin/activate\""* ]] || fail "venv_ros must activate ROS2_VENV"
    [[ "$jazzy_def" == *"source /opt/ros/jazzy/setup.bash; ros_domain"* ]] || fail "jazzy must source Jazzy and set the domain"
    [[ "$jazzy_def" != *"venv_ros"* ]] || fail "jazzy must not activate the virtual environment"
    [[ "$ros2ws_def" == *"venv_ros; jazzy; source \"\$ROS2_WS/install/local_setup.bash\""* ]] || fail "ros2ws activation order differs"
    test "$PS1" = "$EXPECTED_PS1" || fail "prompt must show the ID only after it is set"
  '

# Re-running the installer must not append a duplicate managed block.
HOME="$TEST_HOME" "$SETUP_DIR/04_bashrc_setup.sh" >/dev/null
test "$(grep -c '^# === ros2_lecture bashrc snippet ===$' "$TEST_HOME/.bashrc")" -eq 1

echo "bashrc setup behavior: PASS"
