# Ornably 프로젝트 구조 및 변경 이력

작성 기준: 2026-05-14  
기준 저장소: `C:\HUR\Documents\ornably-hurwan-refactoring`

## 1. 현재 프로젝트 전체 구조 파악

이 저장소는 단일 저장소 안에 백엔드와 프런트엔드를 함께 둔 형태다.

- `ornably/`
  Spring Boot 3.2.2, Java 17, WAR 패키징 기반 백엔드다.  
  JSP 뷰, Spring Security, OAuth2 Client, JDBC, MyBatis, Redis, Solapi, Brevo 연동 코드가 함께 있다.
- `ornably-react/`
  React 19 + Vite 7 기반 프런트엔드다.  
  `react-router-dom`, `axios`, `recharts`, Tailwind 계열 설정을 사용한다.
- `docs/`
  리팩토링 진행 기록과 임시 문서가 들어 있다.
- `ai_docs/`
  AI가 프로젝트를 읽고 정리한 문서를 두기 위한 폴더다.

현재 git 이력상 커밋은 1개뿐이며, 이후 작업은 대부분 아직 커밋되지 않은 워킹 트리 변경으로 남아 있다.  
따라서 아래 이력은 두 구간으로 나눠 기록한다.

1. `git`에 남아 있는 최초 커밋
2. 최초 커밋 이후 현재 워킹 트리에서 확인되는 로컬 변경

## 2. git 기준 최초 형태

### 2026-05-13 23:06:46 +09:00

- 커밋: `6ad53a3507227561e0dbb4e92c5feef5317d4cef`
- 작성자: `hurwan0629`
- 메시지: `원본`

이 커밋은 사실상 프로젝트 전체 원본 import다.

- 총 167개 파일 추가
- 약 27,627줄 추가
- 백엔드 `ornably/` 전체 추가
- 프런트엔드 `ornably-react/` 전체 추가
- 루트 `README.md`는 제목 2줄만 있는 매우 초기 상태

이 시점의 성격은 "백엔드/프런트 원본 코드를 한 번에 가져온 기준점"으로 보는 것이 맞다.

## 3. 최초 커밋 이후 현재까지의 로컬 변경 이력

주의: 아래 구간은 별도 커밋이 아니라 워킹 트리 기준 변경이다.  
시간은 파일 수정 시각과 작업 로그(`docs/refactoring-dev-log/2026-05-14.md`)를 함께 참고했다.

### 2026-05-14 11:41:41 +09:00

초기 리팩토링/정비 흔적이 백엔드 핵심 파일에 들어가기 시작했다.

- `ornably/src/main/java/bugsandwich/ornably/security/LocalUserDetailsService.java`
  기존 로컬 로그인용 `UserDetailsService` 구현이 원본에 존재했다.
  현재 시점 기준으로는 이 파일이 삭제돼 `OrnablyUserService` 중심으로 정리된 상태다.
- `ornably/src/main/resources/SQL/schema.sql`
  전체 DB 스키마 생성 스크립트가 추가됐다.
  `ACCOUNT`, `ITEM`, `EVENT`, `ADDRESS`, `CART`, `WISHLIST`, `REVIEW`, `ORDERS`, `ORDERS_ITEM`, `CONNECT_LOG`를 한 번에 초기화할 수 있게 정리됐다.
- `ornably/src/test/java/com/example/demo/OrnablyApplicationTests.java`
  `@SpringBootTest(classes = bugsandwich.ornably.OrnablyApplication.class)`로 명시해 테스트 부트스트랩 대상을 고정했다.

### 2026-05-14 11:59:19 +09:00

- `ornably/src/main/resources/SQL/sample.sql`
  관리자 계정 seed 데이터가 추가됐다.
  기본 관리자 계정을 DB 초기화 시 같이 넣으려는 목적이 분명하다.

### 2026-05-14 12:11:29 +09:00

- `.gitignore`
  루트 기준 ignore 정책이 추가됐다.
  IDE 산출물, 로그, `.env`, 빌드 결과물, `node_modules`, Docker 데이터 디렉터리, Spring 설정 파일 등을 정리 대상으로 포함했다.

### 2026-05-14 13:05:58 +09:00

- `ornably/docker/dev/docker-compose.yml`
  로컬 개발용 Docker 구성이 추가됐다.
  MySQL 8.4와 Redis 7.2를 띄우고, 백엔드 앱은 컨테이너 밖 로컬 JVM에서 실행하는 방식이다.
  DB 초기화용으로 `schema.sql`, `sample.sql`을 마운트한다.

### 2026-05-14 13:08:59 +09:00

- `ornably/src/main/resources/.env.example`
  로컬 실행 시 필요한 환경변수 예시 파일이 추가됐다.
  포트, DB, Redis, 리소스 경로, Solapi/Brevo, PortOne, OAuth2 관련 값이 정리돼 있다.

### 2026-05-14 13:31:12 +09:00

- `ornably/docker/auto/.env.docker.example`
  Docker 자동 실행용 환경변수 예시가 추가됐다.
  `SPRING_PROFILES_ACTIVE=docker`를 기준으로 외부 주소와 API 키를 주입하는 방향이 정리됐다.

### 2026-05-14 13:34:04 +09:00

- `ornably/docker/auto/docker-compose.yml`
  자동 실행용 compose 파일이 새로 생겼다.
  MySQL, Redis, app 컨테이너를 함께 올리는 구조다.
  앱 이미지는 `hurwan0629/ornably-hurwan:latest`를 기준으로 하면서 동시에 로컬 `Dockerfile` 빌드도 연결돼 있다.

### 2026-05-14 13:43:54 +09:00

- `ornably/Dockerfile`
  멀티스테이지 빌드 기반 Dockerfile이 추가됐다.
  Maven + JDK 17 이미지에서 `war`를 빌드하고, JRE 17 이미지에서 `java -jar app.war`로 실행한다.
  현재 백엔드 배포를 "외부 톰캣 배포"보다 "실행 가능한 WAR 컨테이너화" 쪽으로 정리하려는 의도가 보인다.

### 2026-05-14 13:49:42 +09:00

- `ornably/src/main/resources/SQL/CUSTOM.sql`
  빈 파일이 추가됐다.
  사용자 정의 SQL이나 후속 수동 패치를 위한 placeholder로 보인다.

### 2026-05-14 14:05:03 +09:00

- `ornably/docker/auto/.env.example`
  Docker compose 변수 치환에 필요한 최소값 예시가 추가됐다.
  현재 파일 내용은 `DB_PASSWORD`, `DB_SCHEMA` 두 값만 둔 최소 템플릿이다.

### 2026-05-14 14:05:29 +09:00

- `ornably/docker/auto/docker-compose.override.yml`
  자동 실행용 compose 위에 개발 편의 설정을 덧씌우는 override 파일이 추가됐다.
  MySQL/Redis 포트 노출과 app 포트 `8088:8080` 매핑이 들어 있다.

### 2026-05-14 14:15:36 +09:00

- `ornably/src/ai-docs/2026-05-14.md`
  백엔드 내부에도 별도 AI 작업 메모가 생성됐다.

### 2026-05-14 14:40:06 +09:00

- `README.md`
  단순 제목 2줄이던 루트 README가 프로젝트 소개 문서로 확장됐다.
  리팩토링 목적, 시작일, 작업자, 원본 저장소 링크, 사용 도구가 추가됐다.

### 2026-05-14 14:42:15 +09:00

- `docs/refactoring-dev-log/2026-05-14.md`
  작업 로그가 본격적으로 정리됐다.
  이 문서 안에는 `08:26`, `12:05`, `14:00` 시각 메모가 따로 남아 있으며, 실제로는 다음 내용이 핵심이다.
  - `LocalUserDetailsService`가 테스트/정비 대상이었음
  - Docker 기반 MySQL/Redis 기동 확인
  - `application.properties` 계열을 `dev`/`docker`로 분리하는 작업이 진행됨
  - `.env`, `env_file`, compose 변수 치환 방식 차이를 검증함
  - 로컬 실행 실패 원인을 설정 구조보다 환경변수 주입 문제로 좁힘
  - Dockerfile 필요성과 실행 가능한 WAR 배포 방식까지 검토함

## 4. 현재 변경의 핵심 주제 요약

최초 원본 이후 현재까지의 변경은 기능 추가보다 "실행 환경 정리와 배포 가능성 확보"에 집중돼 있다.

- DB를 코드 추정이 아니라 명시적 SQL 스키마로 관리하려는 방향
- 관리자 seed 데이터 추가
- 로컬 개발용 Docker 구성 정리
- 앱까지 포함한 자동 실행용 Docker 구성 정리
- `.env` 예시 파일 도입으로 환경변수 계약 명시
- 테스트 부트스트랩 보정
- 인증 관련 기존 코드 제거 및 서비스 정리 흔적
- README/작업 로그 등 운영 문서 보강

## 5. git 상태 기준 현재 변경 파일 분류

### 추적 중 파일의 변경/추가

- `.gitignore`
- `README.md`
- `docs/refactoring-dev-log/2026-05-14.md`
- `ornably/Dockerfile`
- `ornably/docker/auto/docker-compose.override.yml`
- `ornably/docker/auto/docker-compose.yml`
- `ornably/docker/auto/.env.docker.example`
- `ornably/docker/auto/.env.example`
- `ornably/docker/dev/docker-compose.yml`
- `ornably/src/ai-docs/2026-05-14.md`
- `ornably/src/main/resources/.env.example`
- `ornably/src/main/resources/SQL/CUSTOM.sql`
- `ornably/src/main/resources/SQL/sample.sql`
- `ornably/src/main/resources/SQL/schema.sql`
- `ornably/src/main/java/bugsandwich/ornably/security/LocalUserDetailsService.java` 삭제
- `ornably/src/test/java/com/example/demo/OrnablyApplicationTests.java`

현재 기준으로 이 문서에 언급된 핵심 변경 파일들은 모두 git이 추적 중이다.

## 6. 한 줄 결론

이 저장소는 git 기록상 아직 "원본 1커밋 + 다수의 미커밋 리팩토링 작업" 상태다.  
현재까지의 변화는 주로 백엔드 실행 환경 표준화, Docker 기반 개발/배포 준비, DB 초기화 자산 정리, 문서화 강화에 집중돼 있다.
