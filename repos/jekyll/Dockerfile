FROM envygeeks/alpine
LABEL jekyll.docker.name "<%= @meta.name %>"
LABEL maintainer "Jordon Bedwell <jordon@envygeeks.io>"
LABEL jekyll.version "<%= @meta.release?? @meta.release : @meta.tag %>"
LABEL jekyll.docker.commit "<%= `git rev-parse --verify HEAD`.strip %>"
LABEL jekyll.docker.tag "<%= @meta.tag %>"
LABEL jekyll.tag "<%= @meta.tag %>"

ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
ENV JEKYLL_DOCKER_TAG=<%= @meta.tag %>
ENV JEKYLL_VERSION=<%= @meta.release?? @meta.release : @meta.tag %>
ENV JEKYLL_DOCKER_COMMIT=<%= `git rev-parse --verify HEAD`.strip %>
<% if @meta.env? %>ENV <%= @meta.env %><% end %>
ENV JEKYLL_DOCKER_NAME=<%= @meta.name %>
ENV JEKYLL_ENV=development
ENV TZ=America/Chicago
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8
COPY copy /

RUN apk update
RUN apk add zlib-dev build-base libxml2-dev \
  libxslt-dev readline-dev libffi-dev ruby-dev \
  yaml-dev zlib-dev libffi-dev less

RUN apk add zlib libxml2 ruby-io-console \
  readline libxslt ruby yaml libffi ruby-irb \
  ruby-json ruby-rake ruby-rdoc git openssl \
  nodejs tzdata

<% if @meta.packages? %>
  RUN apk --update add <%= @meta.packages %>
<% end %>

RUN yes | gem update --system --no-ri --no-rdoc
RUN yes | gem install --force --no-ri --no-rdoc jekyll \
  -v<%= @meta.release?? @meta.release : @meta.tag %>

RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G \
  jekyll jekyll

<% if @meta.gems? %>
  RUN gem install --no-ri --no-rdoc <%=
    @meta.gems
  %>
<% end %>

RUN mkdir -p /usr/share/ruby
RUN echo "<%= @meta.gems %>" > /usr/share/ruby/default-gems
RUN gem install bundler --no-ri --no-rdoc
RUN gem clean

<% if @meta.name == "minimal" %>
  RUN apk del zlib-dev build-base libxml2-dev libxslt-dev readline-dev \
    libffi-dev ruby-dev yaml-dev zlib-dev libffi-dev git
<% end %>

RUN mkdir -p /srv/jekyll && chown -R jekyll:jekyll /srv/jekyll
RUN echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers
RUN cleanup

WORKDIR /srv/jekyll
CMD ["jekyll", "--help"]
VOLUME  /srv/jekyll
EXPOSE 35729 4000
