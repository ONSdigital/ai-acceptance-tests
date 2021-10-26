#FROM maven:3.8.3-jdk-11-slim AS MAVEN_BUILD
FROM maven:3.6.1-jdk-8-alpine AS MAVEN_BUILD

COPY ./ ./

RUN mvn clean package

#FROM openjdk:11-jre
FROM openjdk:8-jre-alpine3.9

COPY --from=MAVEN_BUILD /ai-accetance-tests/target/ai-acceptance-tests-1.0-SNAPSHOT.jar /acceptance.jar

CMD ["java", "-jar", "/acceptance.jar"]