# Jekyll Docker Images

Jekyll Docker is a full featured Ubuntu based Docker image that provides an
isolated Jekyll instance with the latest version of Jekyll and a bunch of nice
stuff to make your life easier when working with Jekyll in both production
and development.

## Current Default Gems

* therubyracer
* pygments.rb
* jekyll-sitemap
* jekyll-coffeescript
* jekyll-sass-converter
* jekyll-redirect-from
* jekyll-mentions
* jekyll-compose
* jekyll-feed
* rdiscount
* redcarpet
* kramdown
* jemoji
* RedCloth
* maruku
* pry

## Boot2Docker Caveats

If you are on Windows using Boot2Docker you will need to `--force_polling`
because there is no built-in support for NTFS notify events to inotify and the
verse, you'll be on two different file systems so only the basic API's
are implemented.

## Gemfiles

This docker image supports Gemfiles.  There is nothing you need to do other
than have the Gemfile in your docker root when you link it to `/srv/jekyll`,
our startup script will detect the Gemfile and `gem install -g` all the gems in
that file.

#### WARNING NOTE

If you do not include "jekyll" in your Gemfile sources then we will move the
Gemfile to Gemfile.docker until you exit out of the image, this is because Gem
does not allow you to have conflicting dependencies so we resolve this by
just moving the file so that Gem can't find it allowing everything to proceed
as normal.

## Running

```sh
docker run --rm -it --volume=$(pwd):/srv/jekyll -p 127.0.0.1:4000:4000 \
  jekyll/jekyll jekyll s
```

***If you do not provide a command then it will default to booting `jekyll s` for you***

## I would like to get a Gem included by default:

We only allow Jekyll gems by default, but you can fork our image and edit
copy/usr/share/jekyll/gems and add your Gem and just hit script/build and it will do
the rest for you.

## Contributing

Please do not edit the Dockerfile unless there is good reason to do so...
because of the way that Docker currently works, there are extreme space probs
in that if we install and cleanup inside of the Docker file our image
size stays the same, please edit `copy/usr/bin/setup` instead.

If you edit anything inside of `copy`, remember the following: Some of our
images use git and make sure to `sync` when you are done because we have to
keep a copy in context for Docker.

## Notes
  * We "shiv" Jekyll to provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * When you launch or run anything via jekyll command it is run as a non-priv user jekyll in /srv/jekyll.
  * Jekyll has access to sudo (mostly for the build system.)

## Building a Deb

```sh
docker run --rm -v $(pwd):/srv/jekyll -it jekyll/jekyll buildeb
```
