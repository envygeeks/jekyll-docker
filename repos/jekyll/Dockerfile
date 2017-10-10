FROM ruby:alpine3.6
LABEL maintainer "Jordon Bedwell <jordon@envygeeks.io>"
COPY copy /

# --
# EnvVars
# System
# --

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ=America/Chicago
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US

# --
# EnvVars
# Image
# --

ENV JEKYLL_DOCKER_TAG=<%= @meta.tag %>
ENV JEKYLL_VAR_DIR=/usr/local/var/jekyll
ENV JEKYLL_VERSION=<%= @meta.release?? @meta.release : @meta.tag %>
ENV JEKYLL_DOCKER_COMMIT=<%= `git rev-parse --verify HEAD`.strip %>
ENV JEKYLL_DOCKER_NAME=<%= @meta.name %>
ENV JEKYLL_DATA_DIR=/srv/jekyll
ENV JEKYLL_ENV=development

# --
# EnvVars
# User
# --

<% if @meta.env? %>
  ENV <%= @meta.env %>
<% end %>

# --
# EnvVars
# Main
# --

env VERBOSE=false
env FORCE_POLLING=false
env DRAFTS=false

# --
# Packages
# User
# --

<% if @meta.packages? %>
  RUN apk --no-cache add <%= @meta.packages %>
<% end %>

# --
# Packages
# Dev
# --

RUN apk --no-cache add \
  zlib-dev \
  build-base \
  libxml2-dev \
  libxslt-dev \
  readline-dev \
  libffi-dev \
  yaml-dev \
  zlib-dev \
  libffi-dev \
  cmake

# --
# Packages
# Main
# --

RUN apk --no-cache add \
  less \
  zlib \
  libxml2 \
  readline \
  libxslt \
  libffi \
  git \
  nodejs \
  tzdata \
  shadow \
  bash \
  su-exec \
  nodejs-npm \
  libressl

# --
# Gems
# Update
# --

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN yes | gem update --system

# --
# Gems
# Main
# --

RUN gem install bundler
RUN gem install jekyll \
  -v<%= @meta.release?? @meta.release : @meta.tag %> -- \
  --use-system-libraries

# --
# Gems
# User
# --

<% if @meta.gems? %>
  # So that Nokogiri doesn't take forever...
  RUN gem install <%=@meta.gems %> -- \
    --use-system-libraries
<% end %>

# --

RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G \
  jekyll jekyll

# --
# Remove development packages on minimal.
# And on pages.  Gems are unsupported.
# --

<% if @meta.name == "minimal" || @meta.name == "pages" || @meta.tag == "pages" %>
  RUN apk --no-cache del \
    zlib-dev \
    build-base \
    libxml2-dev \
    libxslt-dev \
    readline-dev \
    libffi-dev \
    ruby-dev \
    yaml-dev \
    zlib-dev \
    libffi-dev \
    cmake \
    git
<% end %>

# --

RUN mkdir -p /srv/jekyll
RUN mkdir -p /usr/local/var/jekyll
RUN chown -R jekyll:jekyll /srv/jekyll
RUN chown -R jekyll:jekyll /usr/local/var/jekyll
RUN chown -R jekyll:jekyll $GEM_HOME
ENV PATH=/usr/local/bin:$PATH

# --

CMD "jekyll --help"
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729
EXPOSE 4000
