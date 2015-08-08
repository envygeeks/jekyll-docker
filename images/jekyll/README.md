# Jekyll Docker Images

***We no longer use Ubuntu, we now use Alpine Linux for our Docker images
because it provides our users with a smaller image and it can be used in bw
limited countries, there is a huge difference between 90mb and 540mb.***

Jekyll Docker is a full featured Alpine based Docker image that provides an
isolated Jekyll instance with the latest version of Jekyll and a bunch of nice
stuff to make your life easier when working with Jekyll in both production
and development.

## If you are using an `.apt` file.

You can convert your `.apt` file to an `.apk` file but we will do our best
to convert your apt file for you automatically unless you have both then we
we will just use your apk over apt. Visit: http://pkgs.alpinelinux.org if you
would like to search for your package.  If it's only available in testing
then you can do package@testing in your `.apk` file to trigger it from
that repo.

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
Variables`. We also try to detect if if you are using things like Github or Git
to pull dependencies with bundler so that we can transform and optimize for
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
docker run --rm \
  --label=jekyll -p 127.0.0.1:80:4000 -p 127.0.0.1:4000:4000 \
  --volume=$(pwd):/srv/jekyll \
  -e JEKYLL_ENV=development \
  -e UPDATE_GEMFILE=true \
  -e BUNDLE_CACHE=true \
  -e BUNDLER_ARGS="-j 128" \
  -it jekyll/beta \
  sudo -u jekyll bundle exec /usr/local/bin/jekyll serve \
    --watch --drafts --trace "$@"
```

We hit `/usr/local/bin/jekyll` so that it boots as `jekyll:jekyll` but you
can also just do `sudo -u jekyll:jekyll bundle exec jekyll serve` and get the
same thing.

## Building

It's quite simple, `script/build` will build all the images and
`script/build type` will build a specific image, where `type` is `beta` or
another image name.

### Custom account

You can set `JEKYLL_IMAGE_ACCOUNT=account` and it will use your account.
Remember that account is your account, and not some sort of fancy trigger...
Well it is a trigger but `account` should be replaced.

## Contributing

* Fork.
* `.versions/*` holds the version table for images.
* `.gems/*` holds the gem tables for images /usr/share/ruby/default-gems
* DO NOT EDIT `images/*` directly, edit `.gems/*`, `.versions/*`, `Dockerfile`, `copy`
* After you are done, `script/sync`
* script/test

### Notes

* Use `script/build type` to build the image.
* Use `script/sync versions` if you want to update the gem versions.
* Use `test/manual` which will boot up an image so you can browse the demo.
* Use `script/sync pages` if you want to sync pages gem versions!
* Use `script/test` to test the image basics and stuff.

We only verify the image with testing, that means we only check that a few
setup items are created, since most of our base helpers and functions come from
the parent image and are tested there... If you do something special add a
test, they are in test and are mounted when running tests.  If you wish to add
a helper then please consider submitting it to the parent image unless it's
directly related but in most cases it won't be.

## Notes
  * We provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * When you launch or run anything via the `jekyll` cmd it is run as a non-priv
    user `jekyll` with a `uid=1000` and `gid=1000` in `/srv/jekyll`.
  * Jekyll has access to sudo (mostly for the build system.)

## Building a Deb

```sh
docker run --rm -v $(pwd):/srv/jekyll -it jekyll/jekyll buildeb
```
