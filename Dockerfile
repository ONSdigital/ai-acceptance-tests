FROM maven:3.6.1-jdk-8-alpine AS MAVEN_BUILD

COPY ./ ./

ENV BEARER="token here"

RUN mvn clean package

#FROM openjdk:8-jre-alpine3.9

#COPY --from=MAVEN_BUILD /ai-acceptance-tests/target/ai-acceptance-tests-1.0-SNAPSHOT.jar /acceptance.jar

#CMD ["java", "-jar", "/acceptance.jar"]