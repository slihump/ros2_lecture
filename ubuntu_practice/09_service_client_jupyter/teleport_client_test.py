"""
09_서비스_클라이언트_다루기.pdf 실습 코드
turtlesim의 /turtle1/teleport_absolute 서비스를 호출해
거북이를 원하는 좌표로 "한 번에" 순간이동시킨다.

사전 준비:
  1) turtlesim 실행 : ros2 run turtlesim turtlesim_node
  2) (선택) 서비스 목록/타입 확인
     ros2 service list
     ros2 service type /turtle1/teleport_absolute
     ros2 interface show turtlesim/srv/TeleportAbsolute
  3) 이 스크립트 실행 : python3 teleport_client_test.py
"""
import rclpy
from rclpy.node import Node
from turtlesim.srv import TeleportAbsolute


class TeleportClientTest(Node):

    def __init__(self):
        super().__init__('teleport_client_test')
        self.client = self.create_client(TeleportAbsolute, '/turtle1/teleport_absolute')

        # 서버(turtlesim)가 뜰 때까지 1초 간격으로 대기
        while not self.client.wait_for_service(timeout_sec=1.0):
            self.get_logger().info('teleport_absolute 서비스를 기다리는 중...')

    def send_request(self, x, y, theta):
        request = TeleportAbsolute.Request()
        request.x = x
        request.y = y
        request.theta = theta

        future = self.client.call_async(request)
        rclpy.spin_until_future_complete(self, future)
        return future.result()


def main(args=None):
    rclpy.init(args=args)
    node = TeleportClientTest()

    result = node.send_request(x=5.0, y=8.0, theta=1.57)
    node.get_logger().info(f'순간이동 완료. 응답: {result}')

    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
