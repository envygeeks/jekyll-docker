FROM envygeeks/ubuntu:utopic
MAINTAINER Jordon Bedwell <jordon@envygeeks.io>
ENV PATH=$PATH:/opt/jekyll/bin
ENV DEBIAN_FRONTEND=noninteractive
ENV RUBY_VERSION=2.2.0

RUN apt-get update
RUN apt-get dist-upgrade --yes
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

RUN cd /usr/src/ruby-${RUBY_VERSION} && ./configure --prefix=/opt/jekyll \
  --enable-shared \
  --disable-install-doc

RUN cd /usr/src/ruby-${RUBY_VERSION} && make install
RUN rm /usr/src/ruby-${RUBY_VERSION}.tar.gz
RUN rm -r /usr/src/ruby-${RUBY_VERSION}

RUN yes | gem update --system --no-document
RUN yes | gem install jekyll therubyracer --no-document
RUN yes | gem update --no-document

RUN echo libxslt1.1   hold | dpkg --set-selections
RUN echo libreadline6 hold | dpkg --set-selections
RUN echo libyaml-0-2  hold | dpkg --set-selections
RUN echo libxml2      hold | dpkg --set-selections
RUN echo libffi6      hold | dpkg --set-selections

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

EXPOSE 4000
COPY shared/jekyll /usr/bin/jekyll
RUN chmod uog+x /usr/bin/jekyll
