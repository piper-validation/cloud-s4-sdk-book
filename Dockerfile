FROM devxci/mbtci:1.0.15 as builder

USER root

RUN apt-get -y update && apt-get -y install curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl --location --silent "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx -C /usr/local/bin && \
    cf --version

COPY . /app
WORKDIR /app
RUN mbt build
RUN find . -name \*mtar

FROM debian:buster-slim

RUN apt-get -y update && apt-get -y install ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app /app
COPY --from=builder /usr/local/bin/cf /usr/local/bin

RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org && \
    cf install-plugin multiapps -f
