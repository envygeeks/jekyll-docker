#!/bin/bash
set -ex

if [[ "$#" -gt 1 ]]
then
  echo "We only accept a single path."
  exit 1
elif [[ ! -z "$1" ]]
then
  if [[ -d "$1" ]]
    then export PATH=$1:$PATH
  else
    echo "It seems that the path your provided is invalid."
    exit 1
  fi
fi

yes | gem update --no-document
yes | gem install jekyll -v ${JEKYLL_VERSION} --no-document
yes | gem update --system --no-document

for g in $(cat /usr/share/jekyll/gems); do
  yes | gem install "$g" --no-document
done

gem clean
rm -rf /opt/jekyll/lib/ruby/gems/$RUBY_VERSION/cache/*
rm -rf    /usr/lib/lib/ruby/gems/$RUBY_VERSION/cache/*
rm -rf ~/.gem
