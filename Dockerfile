FROM ubuntu:20.04

ARG ERLANG_VERSION=23.0.3
ARG ELIXIR_VERSION=1.10.4-otp-23
ARG NODEJS_VERSION=12.16.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && \
  apt-get install -y \
    bash \
    git \
    curl \
    locales \
    coreutils \
    tzdata \
    libssl-dev \
    build-essential \
    autoconf \
    m4 \
    libncurses5-dev \
    libwxgtk3.0-gtk3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libssh-dev \
    unixodbc-dev \
    xsltproc \
    libxml2-utils \
    libncurses-dev \
    openjdk-11-jdk \
  && apt-get clean

ENV ASDF_ROOT /root/.asdf
ENV PATH "${ASDF_ROOT}/bin:${ASDF_ROOT}/shims:$PATH"

RUN git clone https://github.com/asdf-vm/asdf.git ${ASDF_ROOT} --branch v0.7.8  \
 && asdf plugin-add erlang \
 && asdf plugin-add elixir \
 && asdf plugin-add nodejs \
 && ${ASDF_ROOT}/plugins/nodejs/bin/import-release-team-keyring


 # set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install erlang
RUN asdf install erlang ${ERLANG_VERSION} \
 && asdf global erlang ${ERLANG_VERSION}

# install elixir
RUN asdf install elixir ${ELIXIR_VERSION} \
 && asdf global elixir ${ELIXIR_VERSION}

# install local Elixir hex and rebar
RUN mix local.hex --force \
 && mix local.rebar --force

# install nodejs
RUN asdf install nodejs ${NODEJS_VERSION} \
 && asdf global nodejs ${NODEJS_VERSION}
