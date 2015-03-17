FROM ubuntu:utopic
MAINTAINER Jekyll Core <hello@jekyllrb.com>
ENV RUBY_SHA=5a4de38068eca8919cb087d338c0c2e3d72c9382c804fb27ab746e6c7819ab28
ENV DEBCONF_FRONTEND=noninteractive
ENV PATH=$PATH:/opt/jekyll/bin
ENV JEKYLL_VERSION=2.5.3
ENV RUBY_VERSION=2.2.1

# Double down and have Debian shut it's mouth about term, it's like damn dude.
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN useradd -m -s /bin/bash jekyll
RUN apt-get update && \
  apt-get dist-upgrade --yes && \
  apt-get install --no-install-recommends --yes \
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
    wget \
    deborphan && \
  rm -rf /var/lib/apt/lists/* && \

  cd /usr/src && \
  wget -nv http://cache.ruby-lang.org/pub/ruby/2.2/ruby-${RUBY_VERSION}.tar.gz && \
  $(test "$(sha256sum ruby-${RUBY_VERSION}.tar.gz |cut -d' ' -f1)" = "${RUBY_SHA}" || \
      $(>&2 echo "Bad Download, I'M OUT"; exit 1)) && \

  tar xzf ruby-${RUBY_VERSION}.tar.gz && \
  cd /usr/src/ruby-${RUBY_VERSION} && \
  ./configure --prefix=/opt/jekyll \
    --enable-shared \
    --disable-install-doc && \
  make install -j4 && \
  rm /usr/src/ruby-${RUBY_VERSION}.tar.gz && \
  rm -r /usr/src/ruby-${RUBY_VERSION} && \

  cd ~ && \
  yes | gem update --system --no-document && \
  yes | gem update --no-document && \
  gem install jekyll -v ${JEKYLL_VERSION} --no-document && \
  gem install therubyracer bundler --no-document && \
  rm -rf /opt/jekyll/lib/ruby/gems/2.2.0/cache/* && \
  gem clean && \
  rm -rf ~/.gem && \

  echo libxslt1.1   hold | dpkg --set-selections && \
  echo libreadline6 hold | dpkg --set-selections && \
  echo libyaml-0-2  hold | dpkg --set-selections && \
  echo libxml2      hold | dpkg --set-selections && \
  echo libffi6      hold | dpkg --set-selections && \
  deborphan --add-keep libxml2 libxslt1 libssl libff1 libyaml libreadline6 && \

  apt-get autoremove --purge --yes \
    libssl-dev \
    libreadline6-dev \
    libxslt1-dev libffi-dev \
    $(dpkg --get-selections |grep -- -dev |cut -f1) \
    $(deborphan --guess-all) \
    build-essential \
    libxml2-dev \
    libffi-dev \
    libyaml-dev \
    autoconf \
    wget \
    cpp \
    gcc \
    g++ \
    git && \
    deborphan

RUN mkdir -p /srv/jekyll
WORKDIR /srv/jekyll
RUN  rm /home/jekyll/.bash_logout
RUN  cp ~/.bashrc /home/jekyll/.bashrc
RUN  chown jekyll.jekyll /home/jekyll/.bashrc
RUN  chmod og-rwx /etc/sudoers
COPY copy/ /
EXPOSE 4000
USER jekyll
