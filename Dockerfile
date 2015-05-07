FROM envygeeks/ruby
MAINTAINER Jekyll Core <hello@jekyllrb.com>
ENV PATH=${PATH}:/opt/jekyll/bin
ENV JEKYLL_VERSION=2.5.3

COPY copy/usr/bin/setup /usr/bin/setup
COPY copy/usr/share/jekyll/other/gem/install.bash /usr/share/jekyll/other/gem/install.bash
COPY copy/usr/share/jekyll/gems /usr/share/jekyll/gems
RUN /usr/bin/setup
COPY copy/ /
WORKDIR /srv/jekyll
EXPOSE 4000
