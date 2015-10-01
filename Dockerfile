FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV \
  JEKYLL_IMAGE_TYPE=<%= type %> \
  JEKYLL_GIT_URL=https://github.com/jekyll/jekyll.git \
  JEKYLL_VERSION=<%= version %>
RUN \
  apk --update add readline readline-dev libxml2 libxml2-dev libxslt  \
    libxslt-dev python zlib zlib-dev ruby ruby-dev yaml \
      yaml-dev libffi libffi-dev build-base nodejs ruby-io-console \
        ruby-irb ruby-json ruby-rake ruby-rdoc git nginx && \

  mv /etc/nginx/conf.d /tmp/nginx.conf.d && \
  rm -rf /etc/nginx && mkdir -p /etc/nginx && \
  cd /tmp && git clone https://github.com/envygeeks/docker.git && \
  cd docker/dockerfiles/nginx && cp copy/etc/nginx/* /etc/nginx && \
  mv /tmp/nginx.conf.d /etc/nginx/conf.d && \
  rm -rf /tmp/docker && cd ~/ && \

  mkdir -p /home/jekyll && \
  addgroup -Sg 1000 jekyll &&  \
  adduser  -SG jekyll -u 1000 -h /home/jekyll jekyll && \
  chown jekyll:jekyll /home/jekyll && \

  cd ~ && \
  yes | gem update --system --no-document -- --use-system-libraries && \
  yes | gem update --no-document -- --use-system-libraries && \

  repo=$(docker-helper git_clone_ruby_repo "<%= version %>") && \
  if [ ! -z "$repo" ]; \
  then \
    cd $repo && \
    rake build && gem install pkg/jekyll-*.gem --no-document -- \
      --use-system-libraries && \
    rm -rf $repo; \
  else \
    yes | docker-helper ruby_install_gem \
      "<%= version %>" --no-document -- \
        --use-system-libraries; \
  fi && \

  cd ~ && \
  docker-helper install_default_gems && \
  gem clean && gem install bundler --no-document && \
  apk del build-base readline-dev libxml2-dev libxslt-dev zlib-dev \
    ruby-dev yaml-dev libffi-dev && \

  # Only remove python if we are on 3.0.0+ because it uses Ruby.
  if [ "$(echo $JEKYLL_VERSION | sed -r 's/[^0-9]//g')" -gt 253 ]; \
    then apk del python; \
  fi && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup

WORKDIR /srv/jekyll
EXPOSE 4000 80
