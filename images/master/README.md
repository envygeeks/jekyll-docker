# Jekyll Docker Images

Jekyll Docker is a full featured Ubuntu based Docker image that provides an
isolated Jekyll instance with the latest version of Jekyll and a bunch of nice
stuff to make your life easier when working with Jekyll in both production
and development.

## Current images:

* jekyll/pages
* jekyll/jekyll
* jekyll/stable
* jekyll/master
* jekyll/beta

The jekyll/pages tries to be as close to Github pages as possible,
without changing much, there might be some differences and if there are please
do file a ticket and they will be corrected if possible.

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

This docker image supports Gemfiles, updating your Gemfile and even changing
the way it behaves based on what you tell it to do.  We also try to detect if
if you are using things like Github or Git to pull dependencies with bundler
so that we can transform and optimize for you.

* **Gemfile with a Git(hub)? dependency:** If you have
  `gem "name", :github =>"repo/name"` we will automatically use bundler, but
  this puts everything in your hands as far as dependency management is
  concerned, unless you do one of the latter options.

* **With env var `$UPDATE_GEMFILE`:** If you tell us to update your Gemfile we
  will actually modify your Gemfile and add our default dependencies and make
  sure only uniq entires exist in a very naive way, we will also make sure you
  are on the same Jekyll version the image uses so you are okay on that front.

* **With env var `$BUNDLE_CACHE`:** If you send us $BUNDLE_CACHE we will cache
  your Gems inside of `vendor/bundle` so that you don't have to constantly wait
  for them to reinstall, we know that sometimes RubyGems has uptime problems
  in some areas so this option will help make relieve that pressure.

## Apt dependencies for Gems

We have you covered here too.  If you provide an .apt file inside of your
root we will detect it and install those dependencies inside of the image for
you and attempt to be smart about running it all the time, in that we diff
the Gemfile and if diff says there is a difference we will install and
if there is no difference we will not install them.

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
