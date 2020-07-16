FROM node:14-buster as builder

RUN curl --location --silent "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx -C /usr/local/bin && \
    cf --version

COPY . /app
WORKDIR /app
RUN npm install && npm run ci-build && npm run ci-package && rm -rf node_modules dist

FROM debian:buster-slim

RUN apt-get -y update && apt-get -y install ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app /app
COPY --from=builder /usr/local/bin/cf /usr/local/bin
