FROM ubuntu:20.04

ARG ERLANG=23.1.1
ARG ELIXIR=1.11.1-otp-23
ARG NODEJS=14.15.0
ARG ASDF=v0.8.0

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

RUN git clone https://github.com/asdf-vm/asdf.git ${ASDF_ROOT} --branch ${ASDF} \
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
RUN asdf install erlang ${ERLANG} \
 && asdf global erlang ${ERLANG}

# install elixir
RUN asdf install elixir ${ELIXIR} \
 && asdf global elixir ${ELIXIR}

# install local Elixir hex and rebar
RUN mix local.hex --force \
 && mix local.rebar --force

# install nodejs
RUN asdf install nodejs ${NODEJS} \
 && asdf global nodejs ${NODEJS}
