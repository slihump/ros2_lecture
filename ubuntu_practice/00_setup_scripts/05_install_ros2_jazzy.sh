#!/usr/bin/env bash
# 05_ROS2를_위한_Ubuntu_환경설정.pdf 실습 코드
# Ubuntu 24.04(Noble) 기준, ROS2 Jazzy Desktop을 설치한다.
# 공식 문서: https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
set -e

# 1) locale (UTF-8) 확인/설정
sudo apt update
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 2) universe 저장소 + ROS2 GPG 키/저장소 등록
sudo apt install -y software-properties-common
sudo add-apt-repository universe -y

sudo apt update && sudo apt install -y curl
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
sudo apt install -y /tmp/ros2-apt-source.deb

# 3) 설치
sudo apt update
sudo apt install -y ros-dev-tools
sudo apt install -y ros-jazzy-desktop

echo ""
echo "설치 완료. 매 터미널마다 아래를 실행해야 ros2 명령을 쓸 수 있습니다:"
echo "  source /opt/ros/jazzy/setup.bash"
echo "(06_bashrc_aliases 스크립트로 .bashrc에 등록해두면 편합니다)"
echo ""
echo "설치 확인: 터미널 두 개에서 각각 실행"
echo "  ros2 run demo_nodes_cpp talker"
echo "  ros2 run demo_nodes_py listener"
