# Jekyll Docker Images

Jekyll Docker is a full featured Alpine based Docker image that provides an
isolated Jekyll instance with the latest version of Jekyll and a bunch of nice
stuff to make your life easier when working with Jekyll in both production and
development.

## Tags

* [![](https://badge.imagelayers.io/jekyll/jekyll:latest.svg)][latest] `latest` *current*
* [![](https://badge.imagelayers.io/jekyll/jekyll:2.4.svg)][3.0.1] `3.0.1` *current*
* [![](https://badge.imagelayers.io/jekyll/jekyll:3.0.svg)][3.0] `3.0` *current*
* [![](https://badge.imagelayers.io/jekyll/jekyll:2.4.svg)][3] `3` *current*
* [![](https://badge.imagelayers.io/jekyll/jekyll:2.4.svg)][3.0.0] `3.0.0` *legacy*
* [![](https://badge.imagelayers.io/jekyll/jekyll:2.5.svg)][2.5] `2.5` *legacy*
* [![](https://badge.imagelayers.io/jekyll/jekyll:2.4.svg)][2.4] `2.4` *legacy*
* [![](https://badge.imagelayers.io/jekyll/jekyll:2.4.svg)][2] `2` *legacy*
* [![](https://badge.imagelayers.io/jekyll/jekyll:beta.svg)][beta] `beta` *pending delete*
* [![](https://badge.imagelayers.io/jekyll/jekyll:stable.svg)][stable] `stable` *pending delete*
* [![](https://badge.imagelayers.io/jekyll/jekyll:pages.svg)][pages] `pages` *moving to jekyll/pages at 3.1*
* [![](https://badge.imagelayers.io/jekyll/jekyll:builder.svg)][builder] `builder` *moving to jekyll/builder at 3.1*
* [![](https://badge.imagelayers.io/jekyll/jekyll:master.svg)][master] `master` *pending delete*

[pages]: https://imagelayers.io?images=jekyll/jekyll:pages
[latest]: https://imagelayers.io?images=jekyll/jekyll:latest
[builder]: https://imagelayers.io?images=jekyll/jekyll:builder
[stable]: https://imagelayers.io?images=jekyll/jekyll:stable
[master]: https://imagelayers.io?images=jekyll/jekyll:master
[beta]: https://imagelayers.io?images=jekyll/jekyll:beta
[3.0.1]: https://imagelayers.io?images=jekyll/jekyll:3.0.1
[3.0.0]: https://imagelayers.io?images=jekyll/jekyll:3.0.0
[2.5.3]: https://imagelayers.io?images=jekyll/jekyll:2.5.3
[3.0]: https://imagelayers.io?images=jekyll/jekyll:3.0
[2.5]: https://imagelayers.io?images=jekyll/jekyll:2.5
[2.4]: https://imagelayers.io?images=jekyll/jekyll:2.4
[3]:https://imagelayers.io?images=jekyll/jekyll:3
[2]:https://imagelayers.io?images=jekyll/jekyll:2

The `jekyll/jekyll:pages` tries to be as close to Github pages as possible,
without changing much, there might be some differences and if there are please
do file a ticket and they will be corrected if possible.

## Current Default Gems

* [jekyll-sass-converter][jekyll-sass-converter] - a SASS converter
* [jekyll-coffeescript][jekyll-coffeescript] - a CoffeeScript converter
* [pygments.rb][pygments.rb] - pygments syntax highlighting in ruby
* [rdiscount][rdiscount] - discount (For Ruby) Implementation of John Gruber's Markdown
* [html-proofer][html-proofer] - test your rendered HTML files to make sure they're accurate
* [jekyll-redirect-from][jekyll-redirect-from] - seamlessly specify multiple redirections URLs for your pages and posts
* [jekyll-compose][jekyll-compose] - streamline your writing in Jekyll with these commands
* [jekyll-sitemap][jekyll-sitemap] - silently generate a sitemaps.org compliant sitemap
* [jekyll-feed][jekyll-feed] - generate an Atom (RSS-like) feed of your Jekyll posts
* [RedCloth][redcloth] - a Ruby library for converting Textile into HTML
* [kramdown][kramdown] - fast, pure-Ruby Markdown-superset converter
* [redcarpet][redcarpet] - the safe Markdown parser, reloaded
* [jemoji][jemoji] - GitHub-flavored emoji plugin for Jekyll
* [Maruku][maruku] - a Markdown interpreter written in Ruby
* [jekyll-mentions][jekyll-mentions] - @mention support

[pygments.rb]: https://github.com/tmm1/pygments.rb
[jekyll-sitemap]: https://github.com/jekyll/jekyll-sitemap
[jekyll-coffeescript]: https://github.com/jekyll/jekyll-coffeescript
[jekyll-sass-converter]: https://github.com/jekyll/jekyll-sass-converter
[jekyll-redirect-from]: https://github.com/jekyll/jekyll-redirect-from
[jekyll-mentions]: https://github.com/jekyll/jekyll-mentions
[jekyll-compose]: https://github.com/jekyll/jekyll-compose
[jekyll-feed]: https://github.com/jekyll/jekyll-feed
[rdiscount]: https://github.com/davidfstr/rdiscount
[redcarpet]: https://github.com/vmg/redcarpet
[kramdown]: https://github.com/gettalong/kramdown
[jemoji]: https://github.com/jekyll/jemoji
[redcloth]: https://github.com/jgarber/redcloth
[maruku]: https://github.com/bhollis/maruku
[html-proofer]: https://github.com/gjtorikian/html-proofer

## Running

***If you do not provide a command then it will default to `jekyll s`.***

### On Native Docker

```sh
# Switch to 80:80 or 4000:80 if you wish to use only Nginx with `jekyll build`
docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll \
  -it -p 127.0.0.1:4000:4000 jekyll/jekyll jekyll s
```

### On Docker-Machine, and possibly Boot2Docker
```sh
# Switch to 80:80 or 4000:80 if you wish to use only Nginx with `jekyll build`
docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll \
  -it -p $(docker-machine ip `docker-machine active`):4000:4000 \
    jekyll/jekyll jekyll s
```

If all else fails remove the IP from the `-p` and just do `4000:4000` and
file a ticket and we will help you figure out if this might be a bug in your
networking setup or if this might be a bug with us or an upstream bug.  ***Do
not file a bug if you need to purposefully enable 4000:4000 because you
want access from a public IP***

### Nginx

This image includes Nginx and even adjusting and adding some location stuff or
basic customizations via a `.nginx` folder in your Jekyll root.  These do not
affect the entire server and only affect the server in Jekyll's context, so you
will be able to add locations and other customizations into Jekyll's server
directive.  Nginx exists to allow you to do advanced stuff but our recommended
access is through the default port 4000 right now.

## Boot2Docker Caveats

If you are on Windows or OS X using Boot2Docker you will need to `--force_polling`
because there is no built-in support for NTFS/HFS notify events to inotify and the
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

### Gem installation

When we install gems we first try to install without any system depedencies
assuming you have a few pure Ruby Jekyll gems and then if that fails we will
install common dependencies for you and try again and if that all fails
we will try one last time just to make sure there wasn't an IO error.

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

## Building Only

If you want to just build Jekyll sites, you can use `builder` tag. Additionaly to other
tags, it has:

* ssh
* bash
* rsync
* lftp

Instead of additions, builder does not have Nginx web server.

[Wiki page with examples how to configure CI solutions to use this image](https://github.com/jekyll/docker/wiki/Deploying-with-Jekyll-Docker)

## Building Our Images

It's quite simple, `script/build` will build all the images and `script/build
type` will build a specific image, where `type` is `beta` or another image name.

## Contributing

* Fork the current repo; `bundle install`
* `opts.yml` holds the version, gems and most everything.
* Build all the tags with `bundle exec docker-template jekyll` or tag `docker-template jekyll:tag`
* After you've confirmed your changes boot and can build a site, send a PR.

## Notes
  * We provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * When you launch or run anything via the `jekyll` cmd it is run as a non-priv
    user `jekyll` with a `uid=1000` and `gid=1000` in `/srv/jekyll`.
  * Jekyll has access to sudo (mostly for the build system.)
