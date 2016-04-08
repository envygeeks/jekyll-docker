FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV LANGUAGE=en_US LANG=en_US.UTF-8 LC_ALL=en_US JEKYLL_ENV=production
RUN \
  echo "builder" > /image && \
  apk --update add zlib-dev build-base libxml2-dev libxslt-dev readline-dev libffi-dev ruby-dev yaml-dev nginx && \
  apk --update add zlib python libxml2 zlib-dev build-base libxslt-dev readline-dev ruby-io-console libxml2-dev libffi-dev ruby-dev yaml-dev readline libxslt ruby yaml libffi nodejs ruby-irb ruby-json ruby-rake ruby-rdoc nginx git bash openssh-client lftp && \

  

  mkdir -p /home/jekyll && \
  addgroup -Sg 1000 jekyll &&  \
  adduser  -SG jekyll -u 1000 -h /home/jekyll jekyll && \
  chown jekyll:jekyll /home/jekyll && \

  cd ~ && \
  yes | gem update --system --no-document -- --use-system-libraries && \
  yes | gem update --no-document -- --use-system-libraries && \
  yes | docker-helper ruby_install_gem "jekyll@" \
    --no-document -- --use-system-libraries && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  echo "" > /usr/share/ruby/default-gems && \
  docker-helper install_default_gems && \
  gem clean && gem install bundler \
    --no-document && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  apk del zlib-dev build-base libxml2-dev libxslt-dev readline-dev libffi-dev ruby-dev yaml-dev nginx && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup
WORKDIR /srv/jekyll
EXPOSE 4000 80
