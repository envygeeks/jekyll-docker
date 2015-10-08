# Jekyll Docker Images

Jekyll Docker is a full featured Alpine based Docker image that provides an
isolated Jekyll instance with the latest version of Jekyll and a bunch of nice
stuff to make your life easier when working with Jekyll in both production and
development.

## Current Tags

* [![](https://badge.imagelayers.io/jekyll/jekyll:pages.svg)][pages] `pages`
* [![](https://badge.imagelayers.io/jekyll/jekyll:latest.svg)][latest] `latest`
* [![](https://badge.imagelayers.io/jekyll/jekyll:stable.svg)][stable] `stable`
* [![](https://badge.imagelayers.io/jekyll/jekyll:master.svg)][master] `master`
* [![](https://badge.imagelayers.io/jekyll/jekyll:beta.svg)][beta] `beta`

[pages]: https://imagelayers.io?images=jekyll/jekyll:pages
[latest]: https://imagelayers.io?images=jekyll/jekyll:latest
[stable]: https://imagelayers.io?images=jekyll/jekyll:stable
[master]: https://imagelayers.io?images=jekyll/jekyll:master
[beta]: https://imagelayers.io?images=jekyll/jekyll:beta

The `jekyll/jekyll:pages` tries to be as close to Github pages as possible,
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
verse, you'll be on two different file systems so only the basic API's are
implemented.

## TheRubyRacer (Segfaults)

There is an issue currently with TheRubyRacer and Muslc provided by Alpine, to
work around this you should forgo using TheRubyRacer until it's fixed and rely
on the nodejs we provide with the image.  If you need to use TheRubyRacer you
will need to download and unpack Debian Ruby compiled with glibc and install
glibc@envygeeks, and then reinstall the gems with that Ruby -- GLibC is
available via https://pkgs.envygeeks.io/docker/alpine/x86_64 -- we hope this
issue will resolved soon.

## Nginx

This image includes nginx and even adjusting and adding some location stuff or
basic customizations via a `.nginx` folder in your Jekyll root.  These do not
affect the entire server and only affect the server in Jekyll's context, so you
will be able to add locations and other customizations into Jekyll's server
directive.

## Environment Variables

* `$FORCE_APK_INSTALL` - Will force us to always install `.apk` depenendcies
  for you, regardless of whether we detect a Gemfile, so you can always have
  things you want available.  (WARNING: This is *not* cached.)

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

This docker image supports `Gemfile`'s, updating your Gemfile and even changing
the way it behaves based on what you tell it to do.  See `Environment
Variables`. We also try to detect if if you are using things like Github or Git
to pull dependencies with bundler so that we can transform and optimize for you,
just a tiny bit though.

If you provide a `Gemfile` and that `Gemfile` has a `Git(hub)` dependency we can
quickly detect with a Regexp we will default to installing with bundler so that
we do not break anything that you are trying to accomplish.

## Apk (Alpine) dependencies for Gems

If you provide a `.apk` file inside of your root we will detect it and install
those dependencies inside of the image for you and attempt to be smart about
running it all the time, in that we `diff` the `Gemfile` and if `diff` says
there is a difference we will install and if there is no difference we will not
install them unless there is a `gem` or `bundle` error, and if there is then we
will try to install before trying to install gems again.

### If you are using an `.apt` file.

You can convert your `.apt` file to an `.apk` file but we will do our best to
convert your apt file for you automatically unless you have both. If you do have
both then we we will just use your apk over apt.

Visit: http://pkgs.alpinelinux.org if you would like to search for your package.
If it's only available in testing then you can do package@testing in your `.apk`
file to trigger it from that repo.

## Running

```sh
# Labels requires Docker 1.7, if you get an error remove them.
docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll \
  -it -p 127.0.0.1:4000:4000 jekyll/jekyll jekyll s
```

***If you do not provide a command then it will default to `jekyll s`.***

## Building

It's quite simple, `script/build` will build all the images and `script/build
type` will build a specific image, where `type` is `beta` or another image name.

## Contributing

* Fork the current repo jekyll/docker
* `opts.yml` holds the version, gems and most everything.
* DO NOT EDIT `tags/*` directly, edit stuff in options, `Dockerfile`, and `copy`
* After you are done, `script/sync`, `git commit` and request a patch.

## Notes
  * We provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * When you launch or run anything via the `jekyll` cmd it is run as a non-priv
    user `jekyll` with a `uid=1000` and `gid=1000` in `/srv/jekyll`.
  * Jekyll has access to sudo (mostly for the build system.)
