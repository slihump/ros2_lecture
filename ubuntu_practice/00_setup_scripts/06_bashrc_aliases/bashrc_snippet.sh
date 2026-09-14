# ==========================================================================
#  ROS2 Jazzy 실습용 .bashrc 스니펫  (6강 + 19강 통합/정리본)
#  이 블록을 ~/.bashrc 의 제일 끝에 붙여넣고  `source ~/.bashrc`
# ==========================================================================

# --- 경로 설정 (본인 환경에 맞게 수정) ---
export ROS2_VENV="$HOME/venv/ros"
export ROS2_WS="$HOME/ros2_lecture/ubuntu_practice/ros2_ws"

# --- ROS2 도메인 ID ---
# 셸 시작 시에는 설정하지 않고, jazzy/ros2ws 실행 시 ros_domain 이 98로 설정한다.
# export ROS_DOMAIN_ID=98

# --- 매 터미널 ROS2 환경 자동 적용 안 함 ---
# 필요할 때 jazzy 또는 ros2ws 명령으로 직접 source 한다.
# source /opt/ros/jazzy/setup.bash

# --- ros2 / colcon 자동완성 ---
if [ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ]; then
  source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
fi

# --- 별칭(alias) ---
alias sb='source ~/.bashrc; echo "bashrc reloaded"'
alias ros_domain='export ROS_DOMAIN_ID=98; echo "ROS_DOMAIN_ID=$ROS_DOMAIN_ID"'

# venv만 활성화
alias venv_ros='source "$ROS2_VENV/bin/activate"; echo "venv (ros) activated"'

# jazzy: ROS2 + 도메인 ID만 활성화 (venv는 켜지 않음)
alias jazzy='source /opt/ros/jazzy/setup.bash; ros_domain; echo "ROS2 Jazzy activated"'

# ros2ws: venv + jazzy + 빌드된 워크스페이스를 모두 활성화
alias ros2ws='venv_ros; jazzy; source "$ROS2_WS/install/local_setup.bash"; echo "workspace: $ROS2_WS"'

# 현재 도메인/로컬호스트 설정 확인
get_status() {
  echo "ROS_DOMAIN_ID     : ${ROS_DOMAIN_ID:-0}"
  echo "ROS_LOCALHOST_ONLY : ${ROS_LOCALHOST_ONLY:-0}"
}

# --- 프롬프트에 도메인 ID 표시 (19강) ---
# jazzy/ros2ws로 ROS_DOMAIN_ID가 설정된 경우에만 (ID:xx)를 표시한다.
PS1='${ROS_DOMAIN_ID:+\[\e[1;34m\](ID:${ROS_DOMAIN_ID})\[\e[0m\] }\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
