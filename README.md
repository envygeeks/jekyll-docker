# Jekyll Docker Images

Jekyll Docker is a full featured Alpine based Docker image that provides an isolated Jekyll instance with the latest version of Jekyll and a bunch of nice stuff to make your life easier when working with Jekyll in both production and development.

The `jekyll/jekyll:pages` tag tries to be as close to Github pages as possible, without changing much, there might be some differences and if there are please do file a ticket and they will be corrected if possible... remember not all things can be corrected because sometimes it will just diverge way too much.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Jekyll Docker Images](#jekyll-docker-images)
	- [Running](#running)
		- [On Native Docker](#on-native-docker)
		- [On Docker-Machine / Docker-Toolbox](#on-docker-machine-docker-toolbox)
	- [Docker-Machine Caveats](#docker-machine-caveats)
	- [Gemfiles and Gem Installation](#gemfiles-and-gem-installation)
	- [Apk (Alpine) dependencies for Gems](#apk-alpine-dependencies-for-gems)
	- [Environment Variables](#environment-variables)
	- [Nginx](#nginx)
	- [Default Gems](#default-gems)
	- [Building Only](#building-only)
	- [Building Our Images](#building-our-images)
	- [Contributing](#contributing)

<!-- /TOC -->

## Running

***If you do not provide a command then it will default to `jekyll s`.***

### On Native Docker

```sh
docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll \
  -it -p 127.0.0.1:4000:4000 jekyll/jekyll
```

### On Docker-Machine / Docker-Toolbox
```sh
docker run --rm --label=jekyll --volume=$(pwd):/srv/jekyll \
  -it -p $(docker-machine ip `docker-machine active`):4000:4000 \
    jekyll/jekyll
```

If all else fails remove the IP from the `-p` and just do `4000:4000` and file a ticket and we will help you figure out if this might be a bug in your networking setup or if this might be a bug with us or an upstream bug.  ***Do not file a bug if you need to purposefully enable 4000:4000 because you want access from a public IP***

## Docker-Machine Caveats

If you are on Windows or OS X using Docker-Machine or Boot2Docker you will need to `--force_polling` or send the environment variable `POLLING=true` because there is no built-in support for NTFS/HFS notify events to inotify and the verse, you'll be on two different file systems so only the basic API's are implemented. ***This also applies to docker-machine which either uses boot2docker or is like-it.***

## Gemfiles and Gem Installation

If you provide a `Gemfile` and that `Gemfile` has a `Git(hub)` dependency we can quickly detect with a Regexp we will default to installing with bundler so that we do not break anything that you are trying to accomplish. Otherwise we will do a global install on your behalf (via `gem -g`) so all commands work as normal without `bundle`.  When we install gems we first try to install without any system depedencies assuming you have a few pure Ruby Jekyll gems and then if that fails we will go through and do an `apk` instal dependencies for you and try again and if that all fails we will try one last time just to make sure there wasn't an IO error.

## Apk (Alpine) dependencies for Gems

If you provide a `.apk` file inside of your root we will detect it and install those dependencies inside of the image for you and attempt to be smart about running it all the time, in that we `diff` the `Gemfile` and if `diff` says there is a difference we will install and if there is no difference we will not install them unless there is a `gem` or `bundle` error, and if there is then we will try to install common dependencies plus what's inside of your `.apk` file before trying to install gems again.

## Environment Variables

* `$FORCE_APK_INSTALL` - Force install `.apk` 100% of the time.
* `$BUNDLE_CACHE` - Cache and install to the vendor/bundle folder.
* `$POLLING` - Force polling with `--force_polling`.
* `$VERBOSE` - Enable `jekyll` `--verbose`.

***Upstream support BUNDLE_ARGS and BUNDLE_WITHOUT so that you can add arguments to your bundler and/or exclude specific groups from being installed on your image.***

## Nginx

This image includes Nginx and even adjusting and adding some location stuff or basic customizations via a `.nginx` folder in your Jekyll root.  These do not affect the entire server and only affect the server in Jekyll's context, so you will be able to add locations and other customizations into Jekyll's server directive.  Nginx exists to allow you to do advanced stuff but our recommended access is through the default port 4000 right now.

## Default Gems

The Github (pages tag) may contain dependencies that we don't directly carry, you should also see https://pages.github.com/versions/ to see what extra dependencies that the pages tag might carry, and if you wish them to be included please file a ticket and we'll consider it.

* [jekyll-sass-converter][jekyll-sass-converter]: SASS converter.
* [jekyll-coffeescript][jekyll-coffeescript]: CoffeeScript converter.
* [pygments.rb][pygments.rb]: Pygments syntax highlighting in Ruby.
* [rdiscount][rdiscount]: Discount (For Ruby) Implementation of John Gruber's Markdown.
* [html-proofer][html-proofer]: Test your rendered HTML files to make sure they're accurate.
* [jekyll-redirect-from][jekyll-redirect-from]: Seamlessly specify multiple redirect URLs for your pages and posts.
* [jekyll-compose][jekyll-compose]: Streamline your writing in Jekyll with these commands.
* [jekyll-sitemap][jekyll-sitemap]: Silently generate a sitemaps.org compliant sitemap.
* [jekyll-feed][jekyll-feed]: Generate an Atom (RSS-like) feed of your Jekyll posts.
* [RedCloth][redcloth]: Ruby library for converting Textile into HTML.
* [kramdown][kramdown]: Fast, pure-Ruby Markdown-superset converter.
* [redcarpet][redcarpet]: The safe Markdown parser, reloaded.
* [jemoji][jemoji]: GitHub-flavored emoji plugin for Jekyll.
* [Maruku][maruku]: Markdown interpreter written in Ruby.
* [jekyll-mentions][jekyll-mentions]: @mention support.

## Building Only

If you want to just build Jekyll sites, you can use `builder` tag. Additionaly to other tags, it has: `ssh` (for sftp), `bash`, `rsync`, `lftp` [See the wiki page with examples how to configure CI solutions to use this image](https://github.com/jekyll/docker/wiki/Deploying-with-Jekyll-Docker)

## Building Our Images

You can build our images or any specific tag of an image with `bundle exec docker-template build jekyll` or `bundle exec docker-template build jekyll:tag`, yes it's that simple to build our images even if it looks complicated it's not.

## Contributing

* Fork the current repo; `bundle install`
* `opts.yml` and `repos/*/opts.yml` holds the version, gems and most everything.
* If you are updating to the latest version of Jekyll, the version tables at the top.
* Build all the tags with `bundle exec docker-template build jekyll` or tag `docker-template build jekyll:tag`
* Ensure that your intended changes work as they're supposed to and `docker-template build jekyll --sync-only`
* Ship a pull request if you wish to have it reviewed for all users!

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
