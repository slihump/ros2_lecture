# ==========================================================================
#  ROS2 Jazzy 실습용 .bashrc 스니펫  (6강 + 19강 통합/정리본)
#  이 블록을 ~/.bashrc 의 제일 끝에 붙여넣고  `source ~/.bashrc`
# ==========================================================================

# --- 경로 설정 (본인 환경에 맞게 수정) ---
export ROS2_VENV="$HOME/venv/ros"
export ROS2_WS="$HOME/ros2_lecture/ubuntu_practice/ros2_ws"

# --- ROS2 도메인 ID (같은 네트워크에서 충돌 방지, 강의 기본값 13) ---
export ROS_DOMAIN_ID=13

# --- 매 터미널 ROS2 환경 자동 적용 ---
source /opt/ros/jazzy/setup.bash

# --- ros2 / colcon 자동완성 ---
if [ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ]; then
  source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
fi

# --- 별칭(alias) ---
alias sb='source ~/.bashrc; echo "bashrc reloaded"'
alias ros_domain='export ROS_DOMAIN_ID=13; echo "ROS_DOMAIN_ID=$ROS_DOMAIN_ID"'

# 가상환경 + ROS2 를 한 번에 활성화
alias venv_ros='source "$ROS2_VENV/bin/activate"; echo "venv (ros) activated"'
alias jazzy='venv_ros; source /opt/ros/jazzy/setup.bash; ros_domain; echo "ROS2 Jazzy activated"'

# 빌드된 워크스페이스까지 로드
alias ros2ws='jazzy; source "$ROS2_WS/install/local_setup.bash"; echo "workspace: $ROS2_WS"'

# 현재 도메인/로컬호스트 설정 확인
get_status() {
  echo "ROS_DOMAIN_ID     : ${ROS_DOMAIN_ID:-0}"
  echo "ROS_LOCALHOST_ONLY : ${ROS_LOCALHOST_ONLY:-0}"
}

# --- 프롬프트에 도메인 ID 표시 (19강) ---
__GREEN='\[\e[1;32m\]'; __BLUE='\[\e[1;34m\]'; __NC='\[\e[0m\]'
PS1="${__BLUE}(ID:\${ROS_DOMAIN_ID:-0})${__NC}${__GREEN}\u${__NC}:${__BLUE}\w${__NC}\$ "
