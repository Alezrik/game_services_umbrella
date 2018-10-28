FROM elixir:1.7.3
ENV DEBIAN_FRONTEND=noninteractive


# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force \
    && wget -qO- https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install nodejs -y
WORKDIR /opt/app
ENV MIX_ENV=prod REPLACE_OS_VARS=true
