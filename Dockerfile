FROM maven:3.9-eclipse-temurin-17 AS MAVEN_BUILD

COPY ./ ./

ENTRYPOINT ["mvn", "test"]