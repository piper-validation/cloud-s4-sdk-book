FROM maven:3-jdk-8-slim

RUN curl --location --silent "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx -C /usr/local/bin && \
    cf --version

COPY . /app
WORKDIR /app
RUN mvn install -pl application -Dmaven.test.skip=true
RUN ls -la application/target/address-manager-application.war
