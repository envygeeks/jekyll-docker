FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV <%= @metadata.env %>
RUN \
  echo "<%= @metadata.tag %>" > /image && \
  apk --update add <%= @metadata.development_packages %> && \
  apk --update add <%= @metadata.packages %> && \

  <% if @metadata.tag != "builder" %>
    mv /etc/nginx/conf.d /tmp/nginx.conf.d && \
    rm -rf /etc/nginx && cd /tmp && git clone https://github.com/envygeeks/docker.git && \
    cp -R docker/repos/nginx/copy/all/etc/startup3.d/nginx /etc/startup3.d && \
    cp -R docker/repos/nginx/copy/all/etc/nginx /etc && \
    mv /tmp/nginx.conf.d /etc/nginx/conf.d && \
    rm -rf /tmp/docker && cd ~/ && \
  <% end %>

  mkdir -p /home/jekyll && \
  addgroup -Sg 1000 jekyll &&  \
  adduser  -SG jekyll -u 1000 -h /home/jekyll jekyll && \
  chown jekyll:jekyll /home/jekyll && \

  cd ~ && \
  yes | gem update --system --no-document -- --use-system-libraries && \
  yes | gem update --no-document -- --use-system-libraries && \
  yes | docker-helper ruby_install_gem "jekyll@<%= @metadata.version %>" \
    --no-document -- --use-system-libraries && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  echo "<%= @metadata.gems %>" > /usr/share/ruby/default-gems && \
  docker-helper install_default_gems && \
  gem clean && gem install bundler \
    --no-document && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  apk del <%= @metadata.development_packages %> && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup
WORKDIR /srv/jekyll
EXPOSE 4000 80
