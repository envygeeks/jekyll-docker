FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
<% if (env = @metadata["env"].as_hash).any? %>
ENV <%= @metadata["env"].as_hash.to_env_ary.join(" ") %>
<% end %>
ENV \
  JEKYLL_GIT_URL=https://github.com/jekyll/jekyll.git \
  JEKYLL_VERSION=<%= @metadata.as_gem_version %>
RUN \
  echo "<%= @metadata["tag"] %>" > /image && \
  apk --update add <%= @metadata["pkgs"].as_string_set %> && \

  <% if @metadata["tag"] != "builder" %>
    mv /etc/nginx/conf.d /tmp/nginx.conf.d && \
    rm -rf /etc/nginx && cd /tmp && git clone https://github.com/envygeeks/docker.git && \
    cp -R docker/dockerfiles/nginx/copy/etc/startup3.d/nginx /etc/startup3.d && \
    cp -R docker/dockerfiles/nginx/copy/etc/nginx /etc && \
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

  repo=$(docker-helper git_clone_ruby_repo "<%= @metadata['version'].fallback %>") && \
  if [ ! -z "$repo" ]; \
  then \
    cd $repo && \
    rake build && gem install pkg/jekyll-*.gem --no-document -- \
      --use-system-libraries && \
    rm -rf $repo; \
  else \
    yes | docker-helper ruby_install_gem \
      "jekyll@<%= @metadata['version'].fallback %>" --no-document -- \
        --use-system-libraries; \
  fi && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  <% unless (gems = @metadata["gems"].as_string_set).empty? %>
    echo "<%= gems %>" > /usr/share/ruby/default-gems && \
  <% end %>

  docker-helper install_default_gems && \
  apk del <%= @metadata["remove_pkgs"].as_string_set %> && \
  gem clean && gem install bundler --no-document && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup
WORKDIR /srv/jekyll
EXPOSE 4000 80
