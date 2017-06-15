FROM envygeeks/alpine
MAINTAINER Jekyll Core <hello@jekyllrb.com>
COPY copy/ /
ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
ENV JEKYLL_ENV=development
ENV LC_ALL=en_US
<% if @meta.env? %>
  ENV <%=
    @meta.env
  %>
<% end %>

RUN apk --update add zlib-dev build-base libxml2-dev libxslt-dev readline-dev \
  libffi-dev ruby-dev yaml-dev zlib-dev libxslt-dev readline-dev libxml2-dev libffi-dev \
  ruby-dev yaml-dev zlib libxml2 build-base ruby-io-console readline libxslt ruby \
  yaml libffi nodejs ruby-irb ruby-json ruby-rake ruby-rdoc git openssl

<% if @meta.packages? %>
  RUN apk --update add <%= @meta.packages %>
<% end %>

RUN gem install --no-ri --no-rdoc jekyll -v<%= @meta.release %>
RUN addgroup -Sg 1000 jekyll && adduser -Su 1000 -g 1000 jekyll

<% if @meta.gems? %>
  RUN gem install --no-ri --no-rdoc <%=
    @meta.gems
  %>
<% end %>

RUN mkdir -p /usr/share/ruby
RUN echo "<%= @meta.gems %>" > /usr/share/ruby/default-gems
RUN gem install bundler --no-ri --no-rdoc

RUN mkdir -p /srv/jekyll && chown -R jekyll:jekyll /srv/jekyll
RUN echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers
RUN cleanup
CMD ["/usr/local/bin/jekyll", "--help"]
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 35729 4000
