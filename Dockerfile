# syntax=docker/dockerfile:1

ARG BASE_IMAGE=ruby:3.4
FROM ${BASE_IMAGE}

ARG APT_PACKAGES
ARG APT_PURGE_PACKAGES
ARG COREPACK_PACKAGE_SPECS=""
ARG JEKYLL_ENV=development
ARG JEKYLL_GEM_VERSION=4.4.1
ARG JEKYLL_VERSION=4.4.1
ARG JEKYLL_GEM=jekyll
ARG EXTRA_GEMS=""

ENV \
  COREPACK_HOME=/usr/local/share/corepack \
  JEKYLL_ENV=${JEKYLL_ENV} \
  JEKYLL_VERSION=${JEKYLL_VERSION}

RUN printf '%s\n' \
  'if [ -n "${GEM_HOME:-}" ]; then' \
  '  case ":${PATH}:" in' \
  '    *":${GEM_HOME}/bin:"*) ;;' \
  '    *) export PATH="${GEM_HOME}/bin:${PATH}" ;;' \
  '  esac' \
  'fi' \
  > /etc/profile.d/ruby-gems-path.sh

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends ${APT_PACKAGES} \
  && rm -rf /var/lib/apt/lists/*

RUN \
  mkdir -p "${COREPACK_HOME}" \
  && for package in ${COREPACK_PACKAGE_SPECS}; do \
    corepack prepare "${package}" --activate; \
    corepack enable "${package%@*}"; \
  done

RUN \
  gem install --no-document "${JEKYLL_GEM}" -v "${JEKYLL_GEM_VERSION}" \
  && if [ -n "${EXTRA_GEMS}" ]; then \
    gem install --no-document ${EXTRA_GEMS}; \
  fi

RUN apt-get purge -y --auto-remove ${APT_PURGE_PACKAGES} \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf "${GEM_HOME}/cache" /root/.gem

EXPOSE 4000 35729
WORKDIR /srv/jekyll
CMD ["jekyll", "--help"]
