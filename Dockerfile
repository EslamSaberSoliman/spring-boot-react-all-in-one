# build environment
FROM maven:3.5-jdk-8 
WORKDIR /app
COPY . .
RUN mvn clean && mvn -N io.takari:maven:wrapper
CMD ["./mvnw", "spring-boot:run"]
