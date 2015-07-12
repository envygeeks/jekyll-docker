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

## Environment Variables

* `$UPDATE_GEMFILE` - Will update your Gemfile in a naive way and try
  to sync it and remove duplicates, it will not remove groups (but could remove
  duplicate group names.) and will not remove any blank lines that you add
  yourself even if they are repeated.

  At this time this method is considered alpha unless you know how to
  edit a Gemfile because it doesn't guarantee any uniqueness even if it tries
  in that if we stick a Gem you could end up with two versions, of which
  one you have to remove, including if you have a gem without a version
  and we add one with a version.

* `$BUNDLE_CACHE` - Install to vendor/bundle (by default) so that
  you can cache the gems you install and speed up, this should probably be
  mixed with $UPDATE_GEMFILE or you should add "jekyll" to your gem
  list so you have very little trouble.

## Gemfiles

This docker image supports Gemfiles, updating your Gemfile and even
changing the way it behaves based on what you tell it to do.  See `Environment
Variables`. We also try to detect if if you are using things like Github or Git to pull dependencies with bundler so that we can transform and optimize for
you.

If you provide a Gemfile and that Gemfile has a `Git(hub)` dependency we can
quickly detect with a Regexp we will default to installing with bundler so that
we do not break anything that you are trying to accomplish.

## Apt dependencies for Gems

If you provide an .apt file inside of your root we will detect it and
install those dependencies inside of the image for you and attempt to be smart
about running it all the time, in that we diff the Gemfile and if diff says
there is a difference we will install and if there is no difference we will
not install them unless there is a `gem` or `bundle` error, and if there
is then we will try to install before trying to install gems again.

## Running

```sh
# Labels requires Docker 1.7, if you get an error remove them.
docker run --rm --label=jekyll --label=stable --volume=$(pwd):/srv/jekyll \
  -t -p 127.0.0.1:4000:4000 jekyll/stable jekyll s
```

***If you do not provide a command then it will default to `jekyll s`.***

## A Helper Script to Boot Docker Quickly

You can create a simple `script/dev` script that will make your life
ultra easy with Docker and Jekyll:

```shell
extra_args=()
if [[ "$1" == "debug" ]]
then
  shift
  extra_args+=(
    "--env='NOISY_INSTALL=true'"
  )
fi

docker run --rm \
  --label=envygeeks -p 127.0.0.1:80:4000 -p 127.0.0.1:4000:4000 \
  --volume=$(pwd):/srv/jekyll \
  -e JEKYLL_ENV=development \
  -e UPDATE_GEMFILE=true \
  -e BUNDLE_CACHE=true \
  -e BUNDLER_ARGS="-j 128" \
  ${extra_args[*]} \
  -it jekyll/beta \
  sudo -u jekyll bundle exec /usr/local/bin/jekyll serve \
    --watch --drafts --trace "$@"
```

We hit `/usr/local/bin/jekyll` so that it boots as `jekyll:jekyll` but you
can also just do `sudo -u jekyll:jekyll bundle exec jekyll serve` and get the
same thing.

## Contributing

Please do not edit the Dockerfile unless there is good reason to do so...
because of the way that Docker currently works, there are extreme space probs
in that if we install and cleanup inside of the Docker file our image
size stays the same, please edit `copy/usr/bin/setup` instead.

If you edit anything inside of `copy`, remember the following: Some of our
images use git and make sure to `sync` when you are done because we have to
keep a copy in context for Docker.

## Notes
  * We provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * When you launch or run anything via the `jekyll` cmd it is run as a non-priv
    user `jekyll` with a `uid=1000` and `gid=1000` in `/srv/jekyll`.
  * Jekyll has access to sudo (mostly for the build system.)

## Building a Deb

```sh
docker run --rm -v $(pwd):/srv/jekyll -it jekyll/jekyll buildeb
```
