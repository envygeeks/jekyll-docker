FROM ruby:2.3.1
MAINTAINER Steven Wade "steven@stevenwade.co.uk"

RUN apt-get update \
  && apt-get install -y \
    node \
    python-pygments \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

RUN gem install \
  github-pages \
  jekyll \
  jekyll-redirect-from \
  jekyll-paginate \
  kramdown \
  rdiscount \
  rouge \
  pygments.rb

VOLUME /src
EXPOSE 4000

WORKDIR /src
CMD jekyll serve -d /_site --watch --force_polling -H 0.0.0.0 -P 4000
