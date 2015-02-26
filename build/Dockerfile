FROM envygeeks/jekyll:latest
MAINTAINER Jordon Bedwell <jordon@envygeeks.io>
ENV PATH=/opt/fpm/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive
ENV RUBY_VERSION=2.2.0

RUN apt-get install --no-install-recommends --yes \
  ca-certificates \
  libssl-dev \
  libreadline6-dev \
  libxslt1-dev libffi-dev \
  build-essential \
  libxml2-dev \
  libffi-dev \
  libyaml-dev \
  autoconf \
  git \
  wget

RUN cd /usr/src && wget -nv https://github.com/jekyll/builders/releases/download/v0.1/ruby-${RUBY_VERSION}.tar.gz
RUN cd /usr/src && tar xzvf ruby-${RUBY_VERSION}.tar.gz

RUN cd /usr/src/ruby-${RUBY_VERSION} && ./configure --prefix=/opt/fpm \
  --enable-shared \
  --disable-install-doc

RUN cd /usr/src/ruby-${RUBY_VERSION} && make install
RUN rm /usr/src/ruby-${RUBY_VERSION}.tar.gz
RUN rm -r /usr/src/ruby-${RUBY_VERSION}

RUN yes | gem install fpm --no-document
RUN yes | gem update --system --no-document
RUN yes | gem update --no-document

RUN apt-get autoremove --purge --yes \
  libssl-dev \
  libreadline6-dev \
  libxslt1-dev libffi-dev \
  $(dpkg --get-selections |grep -- -dev |cut -f1) \
  build-essential \
  libxml2-dev \
  libffi-dev \
  libyaml-dev \
  autoconf \
  wget \
  cpp \
  gcc \
  g++ \
  git

RUN apt-get install deborphan --no-install-recommends --yes
RUN deborphan --add-keep libxml2 libxslt1 libssl libff1 libyaml libreadline6
RUN apt-get autoremove --purge $(deborphan --guess-all) --yes
RUN apt-get autoremove --purge deborphan --yes
RUN sudo apt-get autoclean
RUN sudo apt-get clean

COPY shared/buildeb /usr/bin/buildeb
RUN chmod uog+x /usr/bin/buildeb
RUN mkdir -p /srv/fpm/shared
COPY shared/deb/remove.sh  /srv/fpm/shared/
COPY shared/deb/install.sh /srv/fpm/shared/
