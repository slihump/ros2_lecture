#!/usr/bin/env bash
# 05_ROS2를_위한_Ubuntu_환경설정.pdf 실습 코드
# Ubuntu 24.04(Noble) 기준 ROS2 Jazzy Desktop + 5~25강 전체에서 쓰는 apt 패키지 설치.
# 공식 문서: https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
#
# PDF 05 는 GPG 키를 직접 curl 로 받는 옛 방식을 보여주지만,
# 현재 공식 방식은 ros2-apt-source .deb 패키지를 설치하는 것이다(아래).
set -e

# ── 1) locale (UTF-8) ──────────────────────────────────────────────
sudo apt update
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# ── 2) universe 저장소 + ROS2 apt 저장소 등록 ──────────────────────
sudo apt install -y software-properties-common
sudo add-apt-repository universe -y

sudo apt update && sudo apt install -y curl
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest \
  | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb \
  "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
sudo apt install -y /tmp/ros2-apt-source.deb

# ── 3) ROS2 Jazzy Desktop + 개발 도구 ─────────────────────────────
sudo apt update
sudo apt upgrade -y
sudo apt install -y ros-dev-tools
sudo apt install -y ros-jazzy-desktop

# ── 4) 5~25강에서 실제로 쓰는 추가 패키지 ─────────────────────────
sudo apt install -y \
  python3-colcon-common-extensions \
  python3-rosdep \
  ros-jazzy-turtlesim \
  ros-jazzy-tf-transformations \
  ros-jazzy-domain-bridge \
  'ros-jazzy-rqt*' \
  ros-jazzy-rosbag2 \
  ros-jazzy-rosbag2-storage-default-plugins \
  python3-transforms3d \
  python3-pyqt5 \
  python3-matplotlib \
  python3-numpy

# ── 5) rosdep 초기화 (워크스페이스 의존성 자동 설치용) ────────────
sudo rosdep init 2>/dev/null || true
rosdep update || true

echo ""
echo "설치 완료. 새 터미널마다 아래가 필요하다:"
echo "  source /opt/ros/jazzy/setup.bash"
echo "(04_bashrc_setup.sh 로 .bashrc 에 등록하면 자동화됨)"
echo ""
echo "설치 확인: 터미널 두 개에서"
echo "  ros2 run demo_nodes_cpp talker"
echo "  ros2 run demo_nodes_py listener"
