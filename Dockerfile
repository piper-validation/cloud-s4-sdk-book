FROM node:14-buster

RUN curl --location --silent "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx -C /usr/local/bin && \
    cf --version

COPY . /app
WORKDIR /app
RUN npm install && npm run ci-build && npm run ci-package
