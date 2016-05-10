FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV <%= @meta.env %>
RUN \
  apk --update add <%= @meta.development_packages %> && \
  apk --update add <%= @meta.packages %> && \

  mkdir -p /home/jekyll && \
  addgroup -Sg 1000 jekyll &&  \
  adduser  -SG jekyll -u 1000 -h /home/jekyll jekyll && \
  chown jekyll:jekyll /home/jekyll && \

  cd ~ && \
  yes | gem update --system --no-document -- --use-system-libraries && \
  yes | gem update --no-document -- --use-system-libraries && \
  yes | docker-helper ruby_install_gem "jekyll@<%= @meta.version %>" && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  echo "<%= @meta.gems %>" > /usr/share/ruby/default-gems && \
  docker-helper install_default_gems && \
  gem clean && gem install bundler \
    --no-document && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  apk del <%= @meta.development_packages %> && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729 4000 80
