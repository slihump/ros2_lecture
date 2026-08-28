from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    # 14강: launch 로 여러 노드를 한 번에 실행. 두 노드를 같은 namespace(turtlesim)에
    # 넣으면 my_publisher 의 상대 토픽 'turtle1/cmd_vel' 이 '/turtlesim/turtle1/cmd_vel'
    # 로 해석되어 namespace 안의 turtlesim 과 통신한다.
    return LaunchDescription(
        [
            Node(
                namespace="turtlesim", package="turtlesim",
                executable="turtlesim_node", output="screen"),
            Node(
                namespace="turtlesim", package="my_first_package",
                executable="my_publisher", output="screen"),
        ]
    )
