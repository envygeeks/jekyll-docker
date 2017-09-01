FROM ruby:alpine3.6
LABEL jekyll.docker.name "<%= @meta.name %>"
LABEL maintainer "Jordon Bedwell <jordon@envygeeks.io>"
LABEL jekyll.version "<%= @meta.release?? @meta.release : @meta.tag %>"
LABEL jekyll.docker.commit "<%= `git rev-parse --verify HEAD`.strip %>"
LABEL jekyll.docker.tag "<%= @meta.tag %>"
LABEL jekyll.tag "<%= @meta.tag %>"

ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
ENV JEKYLL_DOCKER_TAG=<%= @meta.tag %>
ENV JEKYLL_VAR_DIR=/usr/local/var/jekyll
ENV JEKYLL_VERSION=<%= @meta.release?? @meta.release : @meta.tag %>
ENV JEKYLL_DOCKER_COMMIT=<%= `git rev-parse --verify HEAD`.strip %>
<% if @meta.env? %>ENV <%= @meta.env %><% end %>
ENV JEKYLL_DOCKER_NAME=<%= @meta.name %>
ENV JEKYLL_DATA_DIR=/srv/jekyll
ENV JEKYLL_ENV=development
ENV TZ=America/Chicago
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8
COPY copy /

# --
# User configurable variables.
# @see readme.md
# --

env VERBOSE=false
env FORCE_POLLING=false
env DRAFTS=false

<% if @meta.packages? %>RUN apk --no-cache add <%= @meta.packages %><% end %>
RUN apk --no-cache add zlib-dev build-base libxml2-dev libxslt-dev readline-dev \
  libffi-dev yaml-dev zlib-dev libffi-dev less zlib libxml2 readline libxslt \
    libffi git nodejs tzdata shadow bash su-exec wget nodejs-npm

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN yes | gem update --system
<% if @meta.gems? %>RUN gem install <%=@meta.gems %> -- --use-system-libraries<% end %>
RUN yes | gem install --force jekyll -v<%= @meta.release?? @meta.release : \
  @meta.tag %> -- --use-system-libraries

RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G \
  jekyll jekyll

RUN mkdir -p /usr/share/ruby
RUN echo "<%= @meta.gems %>" > /usr/share/ruby/default-gems
RUN gem install bundler --no-ri --no-rdoc
RUN gem clean

<% if @meta.name == "minimal" %>
  RUN apk --no-cache del zlib-dev build-base libxml2-dev \
    libxslt-dev readline-dev libffi-dev ruby-dev \
      yaml-dev zlib-dev libffi-dev git
<% end %>

RUN mkdir -p /srv/jekyll
RUN mkdir -p /usr/local/var/jekyll
RUN chown -R jekyll:jekyll /srv/jekyll
RUN chown -R jekyll:jekyll /usr/local/var/jekyll
RUN chown -R jekyll:jekyll $GEM_HOME
ENV PATH=/usr/local/bin:$PATH
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729 4000
CMD "jekyll --help"
