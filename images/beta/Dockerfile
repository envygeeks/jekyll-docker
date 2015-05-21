FROM envygeeks/ruby
MAINTAINER Jekyll Core <hello@jekyllrb.com>
ENV JEKYLL_VERSION=3.0.0.pre.beta5

COPY copy/ /
COPY version /
RUN /usr/bin/setup
WORKDIR /srv/jekyll
EXPOSE 4000
