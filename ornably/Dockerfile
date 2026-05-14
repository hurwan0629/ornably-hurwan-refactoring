# 프로젝트 빌드
## Maven + JDK 17 환경에서 프로젝트 빌드
FROM maven:3.9.9-eclipse-temurin-17 as builder

# 빌드용 폴더
WORKDIR /build

# 작업 폴더에 의존성 복사
COPY pom.xml .

COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .

## 의존성 받기
## 소스코드 변경과 무관한 dependency 다운로드 레이어 분리
RUN mvn dependency:go-offline

## 소스 복사
COPY src src

# 테스트 생략 후 패키징 수행
RUN mvn clean package -DskipTests

# 빌드된 프로젝트 실행
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /build/target/*.war app.war

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.war"]