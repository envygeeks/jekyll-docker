FROM envygeeks/ruby
MAINTAINER Jekyll Core <hello@jekyllrb.com>
ENV JEKYLL_VERSION=2.4.0

COPY copy/ /
COPY version /
COPY gems /
RUN /usr/bin/setup
WORKDIR /srv/jekyll
EXPOSE 4000
