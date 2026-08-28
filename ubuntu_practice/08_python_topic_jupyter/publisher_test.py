"""
08_Python으로_ROS2_토픽_다루기.pdf 실습 코드 (발행 파트)
subscription_test.py 로 "구독"을 연습했다면, 이번엔 반대로 "발행"을 연습한다.

사전 준비:
  1) turtlesim 실행 : ros2 run turtlesim turtlesim_node
  2) 이 스크립트 실행 : python3 publisher_test.py
  3) 다른 터미널에서 확인 : ros2 topic echo /turtle1/cmd_vel
     -> 거북이가 계속 원을 그리며 움직이는 것을 볼 수 있다
"""
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist


class PublisherTest(Node):

    def __init__(self):
        super().__init__('publisher_test')
        self.publisher = self.create_publisher(Twist, '/turtle1/cmd_vel', 10)
        # 1초마다 timer_callback을 호출하는 타이머 등록
        self.timer = self.create_timer(1.0, self.timer_callback)

    def timer_callback(self):
        msg = Twist()
        msg.linear.x = 1.0
        msg.angular.z = 1.0
        self.publisher.publish(msg)
        self.get_logger().info('cmd_vel 발행: linear.x=1.0, angular.z=1.0')


def main(args=None):
    rclpy.init(args=args)
    node = PublisherTest()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
