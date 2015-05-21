FROM envygeeks/ruby
MAINTAINER Jekyll Core <hello@jekyllrb.com>
ENV JEKYLL_VERSION=2.5.3

COPY copy/ /
COPY version /
RUN /usr/bin/setup
WORKDIR /srv/jekyll
EXPOSE 4000
