# ROS2 5~25강 실습

PinkLAB &ldquo;무작정 따라하는 ROS2&rdquo; **5강 ~ 25강**을, 아무것도 설치 안 된 Ubuntu 24.04 에서
복사·붙여넣기만으로 끝까지 진행할 수 있게 정리한 실습 코드 + 가이드입니다.

- **대상 환경**: Ubuntu 24.04 (Noble) · ROS2 Jazzy · Python 3.12
- `ubuntu_practice/` — 07~25강 실습 소스 (버그 수정 완료, `colcon build` 통과 확인)
- `ros2_5-25_guide.html` — 명령어를 순서대로 따라치기만 하면 되는 실습 가이드 (사진 포함, 단일 파일)

---

## 시작하기

### 1. 홈(`~`)에 클론

```bash
git clone https://github.com/slihump/ros2_lecture.git ~/ros2_lecture
```

> ⚠️ 반드시 홈(`~`)에 클론하세요. WSL2 라면 `/mnt/c/...` (윈도우 폴더) 안에 두면
> `colcon build` 가 매우 느리고 권한 문제가 납니다.

### 2. 가이드(HTML) 열기

브라우저로 `~/ros2_lecture/ros2_5-25_guide.html` 를 엽니다.

```bash
# WSL2 → Windows 기본 브라우저로 열기
cd ~/ros2_lecture && explorer.exe ros2_5-25_guide.html
```

(안 되면 파일 탐색기에서 `\\wsl.localhost\Ubuntu\home\<사용자>\ros2_lecture\ros2_5-25_guide.html`
더블클릭, 또는 Windows 로 파일을 복사해서 열어도 됩니다. 이미지가 파일에 포함돼 있어 어디서 열어도 그대로 보입니다.)

### 3. 가이드대로 진행

가이드의 **준비 A → B → C** 를 한 번 실행한 뒤, **07강 ~ 25강**을 순서대로 따라갑니다.
필요한 설치·가상환경·빌드 명령이 모두 가이드 안에 순서대로 들어 있습니다.
