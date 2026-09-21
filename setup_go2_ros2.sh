#!/usr/bin/env bash
# Source this file with: go2ros
if [ -n "${VIRTUAL_ENV:-}" ] && declare -F deactivate >/dev/null; then
    deactivate
fi
if [ -n "${CONDA_PREFIX:-}" ]; then
    conda deactivate || return 1
fi
source /opt/ros/jazzy/setup.bash || return 1
source "$HOME/unitree_ros2/cyclonedds_ws/install/setup.bash" || return 1
if [ -f "$HOME/ws/hesai_ws/install/local_setup.bash" ]; then
    source "$HOME/ws/hesai_ws/install/local_setup.bash" || return 1
fi

_go2_iface="$(ip -o -4 addr show | awk '$4 ~ /^192\.168\.123\./ {print $2; exit}')"
if [ -z "$_go2_iface" ]; then
    echo '[Go2] Connect the Ethernet cable and activate the Go2 network profile: nmcli connection up Go2'
    unset _go2_iface
    return 1
fi
export ROS_DOMAIN_ID=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
unset ROS_LOCALHOST_ONLY
export ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET
export CYCLONEDDS_URI="<CycloneDDS><Domain><General><Interfaces><NetworkInterface name=\"$_go2_iface\" priority=\"default\" multicast=\"default\" /></Interfaces></General><Discovery><MaxAutoParticipantIndex>80</MaxAutoParticipantIndex></Discovery></Domain></CycloneDDS>"
echo "[Go2] Jazzy | CycloneDDS | domain $ROS_DOMAIN_ID | interface $_go2_iface"
unset _go2_iface
