FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV LANGUAGE=en_US LANG=en_US.UTF-8 LC_ALL=en_US
RUN \
  echo "3.1.2" > /image && \
  apk --update add zlib-dev build-base libxml2-dev libxslt-dev readline-dev libffi-dev ruby-dev yaml-dev && \
  apk --update add zlib python libxml2 zlib-dev build-base libxslt-dev readline-dev ruby-io-console libxml2-dev libffi-dev ruby-dev yaml-dev readline libxslt ruby yaml libffi nodejs ruby-irb ruby-json ruby-rake ruby-rdoc nginx git && \

  
    mv /etc/nginx/conf.d /tmp/nginx.conf.d && \
    rm -rf /etc/nginx && cd /tmp && git clone https://github.com/envygeeks/docker.git && \
    cp -R docker/repos/nginx/copy/all/etc/startup3.d/nginx /etc/startup3.d && \
    cp -R docker/repos/nginx/copy/all/etc/nginx /etc && \
    mv /tmp/nginx.conf.d /etc/nginx/conf.d && \
    rm -rf /tmp/docker && cd ~/ && \
  

  mkdir -p /home/jekyll && \
  addgroup -Sg 1000 jekyll &&  \
  adduser  -SG jekyll -u 1000 -h /home/jekyll jekyll && \
  chown jekyll:jekyll /home/jekyll && \

  cd ~ && \
  yes | gem update --system --no-document -- --use-system-libraries && \
  yes | gem update --no-document -- --use-system-libraries && \
  yes | docker-helper ruby_install_gem "jekyll@3.1.2" \
    --no-document -- --use-system-libraries && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  echo "pygments.rb jekyll-sitemap jekyll-mentions jekyll-coffeescript jekyll-sass-converter jekyll-redirect-from jekyll-paginate jekyll-compose jekyll-feed rdiscount redcarpet kramdown jemoji RedCloth maruku html-proofer" > /usr/share/ruby/default-gems && \
  docker-helper install_default_gems && \
  gem clean && gem install bundler \
    --no-document && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  apk del zlib-dev build-base libxml2-dev libxslt-dev readline-dev libffi-dev ruby-dev yaml-dev && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup
WORKDIR /srv/jekyll
EXPOSE 4000 80
