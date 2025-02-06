FROM gradle:8.11.1-jdk17
# 소스 코드를 복사할 작업디렉토리를 생성
WORKDIR /myapp
# 호스트머신에 소스코드를 이미지 작업 디렉토리로 복사
COPY . /myapp
# 이전 빌드에서 생성된 모든 build/ 디렉토리내용을 삭제, 새롭게 빌드
# 프로젝트를 빅드
# --no-deamon -> 데몬 실행 하지 않음
#gradle 은 설치되어있는 gradle 은 설치되어 있는  그래들 이용해서 빌드 그래등은 프로젝트에 포함된 그래들을 이용
#CID에서는 gradlew를 이용해서
# -x test -> test 제외
RUN chmod +x gradlew
RUN gradlew clean build --no-deamon -x test

# 자바를 실행하기 위한 작업
FROM openjdk:17-alpine
WORKDIR /myapp
# 프로젝트 빌드로 생성한 jar파일을 런타임 이미지로 복사
COPY --from=build /myapp/build/*.jar /myapp/orderservice.jar
EXPOSE 9200
ENTRYPOINT ["java", "-jar", "/orderservice.jar"]
