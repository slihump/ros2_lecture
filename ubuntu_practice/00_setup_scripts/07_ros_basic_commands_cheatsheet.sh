#!/usr/bin/env bash
# 07_ROS_기초명령.pdf 실습 코드
# 이 파일은 실행용이 아니라 "한 줄씩 따라 치는" 치트시트입니다.
# turtlesim을 켠 상태에서 다른 터미널에 한 줄씩 복사해서 실행해보세요.

# --- 0) turtlesim 준비 ---
# sudo apt install ros-jazzy-turtlesim
# ros2 run turtlesim turtlesim_node

# --- 1) 노드(Node) ---
# ros2 node list
# ros2 node info /turtlesim

# --- 2) 서비스(Service) : 1회 요청 -> 1회 응답 ---
# ros2 service list
# ros2 service type /spawn
# ros2 interface show turtlesim/srv/Spawn
# ros2 service call /spawn turtlesim/srv/Spawn "{x: 2, y: 2, theta: 0, name: 'turtle2'}"

# --- 3) 토픽(Topic) : 계속 흐르는 방송 ---
# ros2 topic list -t
# ros2 topic echo /turtle1/pose
# ros2 topic pub /turtle1/cmd_vel geometry_msgs/msg/Twist "{linear: {x: 2.0}, angular: {z: 1.8}}"

# --- 4) 액션(Action) : 목표 + 중간 피드백 + 결과 ---
# ros2 action list
# ros2 interface show turtlesim/action/RotateAbsolute
# ros2 action send_goal /turtle1/rotate_absolute turtlesim/action/RotateAbsolute "{theta: 1.57}" --feedback

# --- 5) 전체 그림 보기 ---
# rqt_graph
