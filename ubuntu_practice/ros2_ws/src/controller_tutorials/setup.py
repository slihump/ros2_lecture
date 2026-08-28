from setuptools import find_packages, setup

package_name = 'controller_tutorials'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='pw',
    maintainer_email='pw@todo.todo',
    description='주행제어기 실습 (22~25강)',
    license='Apache-2.0',
    #tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            # 22강 - Bang-Bang 회전 제어
            'simple_rotate = controller_tutorials.simple_rotate:main',
            # 23강 - PID 회전 제어
            'control_rotate = controller_tutorials.control_rotate:main',
            # 24강 - 위치 Dual PID + 모니터
            'pose_dual_controller = controller_tutorials.pose_dual_controller:main',
            'qmonitor_for_pose_dual_controller = controller_tutorials.qmonitor_for_pose_dual_controller:main',
            'monitor_for_pose_dual_controller = controller_tutorials.monitor_for_pose_dual_controller:main',
            # 25강 - 상태머신 주행 제어 + 모니터
            'move_turtle = controller_tutorials.move_turtle:main',
            'monitor_for_move_turtle = controller_tutorials.monitor_for_move_turtle:main',
            'move_turtle_state_machine = controller_tutorials.move_turtle_state_machine:main',
            'qmonitor_state_machine = controller_tutorials.qmonitor_state_machine:main',
            # 25강 보너스 - 비교용 Behavior Tree 구현 / 웹 모니터용 노드
            'move_turtle_behavior_tree = controller_tutorials.move_turtle_behavior_tree:main',
            'web_publisher_node = controller_tutorials.web_publisher_node:main',
        ],
    },
)
