#!/bin/bash
set -ex

apt-get update
apt-get dist-upgrade --yes
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
  deborphan
rm -rf /var/lib/apt/lists/*

cd /usr/src
wget -nv http://cache.ruby-lang.org/pub/ruby/2.2/ruby-${RUBY_VERSION}.tar.gz
$(test "$(sha256sum ruby-${RUBY_VERSION}.tar.gz |cut -d' ' -f1)" = "${RUBY_SHA}" || \
  $(>&2 echo "Bad Download, I'M OUT"; exit 1)) && \

tar xzf ruby-${RUBY_VERSION}.tar.gz
cd /usr/src/ruby-${RUBY_VERSION}
./configure --prefix=/opt/jekyll \
  --enable-shared \
  --disable-install-doc
make install -j4
rm /usr/src/ruby-${RUBY_VERSION}.tar.gz
rm -r /usr/src/ruby-${RUBY_VERSION}

cd ~
yes | gem update --system --no-document
yes | gem update --no-document
yes | gem install jekyll -v ${JEKYLL_VERSION} --no-document
yes | gem install therubyracer bundler --no-document
rm -rf /opt/jekyll/lib/ruby/gems/2.2.0/cache/*
gem clean
rm -rf ~/.gem

echo libxslt1.1   hold | dpkg --set-selections
echo libreadline6 hold | dpkg --set-selections
echo libyaml-0-2  hold | dpkg --set-selections
echo libxml2      hold | dpkg --set-selections
echo libffi6      hold | dpkg --set-selections

deborphan --add-keep libxml2 libxslt1 libssl libff1 libyaml libreadline6
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
  git \
  deborphan

mkdir -p /srv/jekyll
rm /home/jekyll/.bash_logout
cp ~/.bashrc /home/jekyll/.bashrc
chown jekyll.jekyll /home/jekyll/.bashrc
chown jekyll.jekyll /home/jekyll /srv/jekyll
chmod og-rwx /etc/sudoers
