"""
08_Python으로_ROS2_토픽_다루기.pdf 실습 코드
원래는 Jupyter Notebook 셀을 하나씩 실행하며 익히는 내용이지만,
터미널에서 바로 연습할 수 있도록 스크립트 한 파일로 정리했다.

사전 준비:
  1) turtlesim 실행 : ros2 run turtlesim turtlesim_node
  2) (선택) 다른 터미널에서 조종 : ros2 run turtlesim turtle_teleop_key
  3) 이 스크립트 실행 : python3 subscription_test.py
     -> ROS2 환경이 source 되어 있고, rclpy가 설치된 가상환경/시스템 파이썬이면 됨
"""
import rclpy
from turtlesim.msg import Pose

# 0) rclpy 초기화 (Jazzy 에서는 create_node 전에 반드시 필요)
rclpy.init()

# 1) 노드 생성
node = rclpy.create_node('subscription_test')


# 2) 콜백 함수 : 토픽이 도착할 때마다 호출된다
def callback(msg: Pose):
    print(f"x={msg.x:.2f}, y={msg.y:.2f}, theta={msg.theta:.2f}")


# 3) 구독 등록 : turtle1/pose 토픽을 Pose 타입으로 구독
subscription = node.create_subscription(Pose, '/turtle1/pose', callback, 10)

print("turtle1/pose 구독 시작. Ctrl+C로 종료하세요.")

# 4) spin_once를 여러 번 돌려서 콜백이 몇 번 호출되는지 체감해보기
for i in range(20):
    rclpy.spin_once(node)

print("이제부터는 계속 구독 (spin) -- Ctrl+C로 멈추세요")

# 5) 계속 구독하려면 spin
try:
    rclpy.spin(node)
except KeyboardInterrupt:
    pass
finally:
    node.destroy_node()
    rclpy.shutdown()
