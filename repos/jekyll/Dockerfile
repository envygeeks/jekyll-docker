FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV \
  LANGUAGE=en_US \
  LANG=en_US.UTF-8 \
  JEKYLL_ENV=development \
  LC_ALL=en_US
<% if @meta.env? %>
  ENV <%=
    @meta.env
  %>
<% end %>
RUN \
  apk --update add zlib-dev build-base libxml2-dev libxslt-dev readline-dev \
    libffi-dev ruby-dev yaml-dev zlib-dev libxslt-dev readline-dev libxml2-dev \
    libffi-dev ruby-dev yaml-dev zlib libxml2 build-base ruby-io-console readline \
    libxslt ruby yaml libffi nodejs ruby-irb ruby-json ruby-rake ruby-rdoc \
    git <% if @meta.packages? %><%= @meta.packages %><% end %> && \

  gem install --no-ri --no-rdoc jekyll -v<%= @meta.release %> && \
  addgroup -Sg 1000 jekyll && adduser -Su 1000 -g 1000 jekyll && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  echo "<%= @meta.gems %>" > /usr/share/ruby/default-gems && \
  gem install bundler --no-ri --no-rdoc && \
  gem install --no-ri --no-rdoc <%= @meta.gems %> && \

  mkdir -p /srv/jekyll && chown -R jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  cleanup
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729 4000
