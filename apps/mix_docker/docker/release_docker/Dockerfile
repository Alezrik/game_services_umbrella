FROM elixir:1.7.3
#
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
      bash \
      libssl-dev
EXPOSE 8000
ENV PORT=8000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/bash
WORKDIR /app
