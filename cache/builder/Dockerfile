FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /

ENV LANGUAGE=en_US LANG=en_US.UTF-8 LC_ALL=en_US JEKYLL_ENV=production

ENV \
  JEKYLL_GIT_URL=https://github.com/jekyll/jekyll.git \
  JEKYLL_VERSION=jekyll@3.0.2
RUN \
  echo "builder" > /image && \
  apk --update add zlib python libxml2 zlib-dev build-base libxslt-dev readline-dev ruby-io-console libxml2-dev libffi-dev ruby-dev yaml-dev readline libxslt ruby yaml libffi nodejs ruby-irb ruby-json ruby-rake ruby-rdoc nginx git bash openssh-client lftp && \

  

  mkdir -p /home/jekyll && \
  addgroup -Sg 1000 jekyll &&  \
  adduser  -SG jekyll -u 1000 -h /home/jekyll jekyll && \
  chown jekyll:jekyll /home/jekyll && \

  cd ~ && \
  yes | gem update --system --no-document -- --use-system-libraries && \
  yes | gem update --no-document -- --use-system-libraries && \

  repo=$(docker-helper git_clone_ruby_repo "3.0.2") && \
  if [ ! -z "$repo" ]; \
  then \
    cd $repo && \
    rake build && gem install pkg/jekyll-*.gem --no-document -- \
      --use-system-libraries && \
    rm -rf $repo; \
  else \
    yes | docker-helper ruby_install_gem \
      "jekyll@3.0.2" --no-document -- \
        --use-system-libraries; \
  fi && \

  cd ~ && \
  mkdir -p /usr/share/ruby && \
  
    echo "pygments.rb jekyll-sitemap jekyll-mentions jekyll-coffeescript jekyll-sass-converter jekyll-redirect-from jekyll-compose jekyll-feed rdiscount redcarpet kramdown jemoji RedCloth maruku html-proofer" > /usr/share/ruby/default-gems && \
  

  docker-helper install_default_gems && \
  apk del zlib-dev build-base libxml2-dev libxslt-dev readline-dev libffi-dev ruby-dev yaml-dev nginx && \
  gem clean && gem install bundler --no-document && \

  mkdir -p /srv/jekyll && \
  chown jekyll:jekyll /srv/jekyll && \
  echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers && \
  rm -rf /usr/lib/ruby/gems/*/cache/*.gem && \
  docker-helper cleanup
WORKDIR /srv/jekyll
EXPOSE 4000 80
