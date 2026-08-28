#!/usr/bin/env bash
# 10강부터 쓰는 ROS2 워크스페이스(ros2_ws)를 처음 한 번 빌드한다.
#
# 실행 전:
#   source ~/venv/ros/bin/activate
#   source /opt/ros/jazzy/setup.bash
#   (또는 .bashrc 스니펫 적용 후  jazzy  명령)
set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS="$(cd "$HERE/../ros2_ws" && pwd)"
cd "$WS"

echo "워크스페이스: $WS"

# 1) 시스템 의존성 자동 설치 (package.xml 기반)
if command -v rosdep >/dev/null 2>&1; then
  rosdep install --from-paths src --ignore-src -r -y || true
fi

# 2) 빌드
colcon build --symlink-install

echo ""
echo "빌드 완료. 사용:"
echo "  source $WS/install/local_setup.bash"
echo ""
echo "메시지 패키지(my_first_package_msgs) 빌드가"
echo "  \"module 'em' has no attribute 'Interpreter'\"  로 실패하면(11강):"
echo "  python -m pip install 'empy==3.3.4' catkin_pkg lark   # 가상환경 안에서"
echo "  rm -rf build install log && colcon build --symlink-install"
