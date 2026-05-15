# 윈도우와 리눅스에서의 DBMS 동작 차이

DBMS에서는 위 두 운영체제에 따른 SQL문법, DB 기능 차이도 있지만 핵심 차이는 아래와 같다.
**DBMS는 같은 제품이라도 운영 체제에 따라 설치 방식, 서비스 관리, 파일 경로, 권한, 성능 튜닝, 운영 안정성 방식이 달라진다**

공통 차이는 아래와 같다.
| 구분     | Windows                            | Linux                                  |
| ------ | ---------------------------------- | -------------------------------------- |
| 실행 방식  | Windows 서비스                        | systemd 서비스                            |
| 서비스 관리 | `services.msc`, 작업 관리자, PowerShell | `systemctl`, `journalctl`, `ps`, `top` |
| 파일 경로  | `C:\Program Files\...`             | `/var/lib/...`, `/etc/...`, `/usr/...` |
| 권한     | 관리자 권한, 서비스 계정                     | root, 전용 OS 계정, 파일 권한                  |
| 로그 확인  | 이벤트 뷰어, DB 로그 파일                   | `/var/log`, DB 로그, `journalctl`        |
| 자동 시작  | 서비스 시작 유형                          | systemd enable                         |
| 운영 선호도 | 개발/테스트용도 많음                        | 실서버 운영에 더 흔함                           |
| 성능 튜닝  | GUI 편함, OS 튜닝 제한적                  | 커널/파일시스템/메모리 튜닝 유리                     |
| 백업/자동화 | PowerShell, 작업 스케줄러                | shell script, cron, systemd timer      |

우선 서비스를 관리하는 주체가 다른것을 확인 가능하며 경로 또한 윈도우는 `C:\`, Linux는 `var/lib/`, `/etc/`, `usr/`이다.

## Oracle
Oracle는 실제 운영에서는 Linux를 많이 쓰며 Window에서는 Windows서비스로 등록되며 환경변수 설정이 중요하다. 또한 파일 경로가 Windows식이다.

리눅스에서는 전용 OS 계정 `oracle`를 사용하며 그룹 설정 또한 `oinstall`, `dba`이 존재한다.
커널 파라미터, 메모리, limits 설정이 중요하며 서비스 관리는 `systemd` 또는 Oracle 자체 스크립트를 사용한다.

## MySQL

윈도우 에서는 파일 위치가 다음과 같다.
설정파일: `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
데이터 디렉터리: `C:\ProgramData\MySQL\MySQL Server 8.0\Data`

리눅스는
`sudo apt install mysql-server` 등을 통해 받게 되며 
설정 파일 또한
`etc/mysql/my.cnf`
`/etc/mysql/mysql.conf.d/mysqld.cnf` 와 같다.

# 주의점
Window에서 개발을 할 때에는 MySQL의 주의점은
- root계정 쓰지 않기
- 문자셋은 안정적인 utf8mb4 쓰기
- 윈도우에서 엄격하지 않은 대소문자 구분 확실하게 하기. 
- window 경로 공백 신경쓰기
- 비밀번호에 `#` 들어가면 주석과 구분되게 작성하기
- Timezone존재할 대 url에 기재하기
등이 있다.