ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/base:9.26.0@sha256:d64249bced930342154688a79d0bc537423c2e5918c476361e0e22f5fd734c83 AS base

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.19.0

RUN corepack enable

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7

# --------------------------------------
# slim image
# --------------------------------------
FROM base as slim-base

# --------------------------------------
# full image
# --------------------------------------
FROM base as full-base

# renovate: datasource=adoptium-java
RUN install-tool java 17.0.9+9

# renovate: datasource=gradle-version versioning=gradle
RUN install-tool gradle 8.5

# renovate: datasource=github-releases lookupName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 26.1.2.0

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.15.7

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 8.2.13

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.6.5

# renovate: datasource=golang-version
RUN install-tool golang 1.21.4

# renovate: datasource=github-releases lookupName=containerbase/python-prebuild
RUN install-tool python 3.11.5

# renovate: datasource=pypi
RUN install-tool pipenv 2023.11.15

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.7.1

# renovate: datasource=pypi
RUN install-tool hashin 0.17.0

# renovate: datasource=pypi
RUN install-tool pip-tools 7.3.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.74.0

# renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
RUN install-tool ruby 3.2.2

# renovate: datasource=rubygems versioning=ruby
RUN install-tool bundler 2.4.22

# renovate: datasource=rubygems versioning=ruby
RUN install-tool cocoapods 1.14.3

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 7.0.404

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 8.10.5

# renovate: datasource=npm versioning=npm
RUN install-tool lerna 7.4.2

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.13.2

# renovate: datasource=github-releases lookupName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

# renovate: datasource=npm
RUN install-tool bun 1.0.14

# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.19.2

# renovate: datasource=github-tags packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.19.0

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION
ARG BASE_IMAGE_REVISION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}" \
  org.opencontainers.image.revision="${BASE_IMAGE_REVISION}"

