[![Build Status](https://travis-ci.org/jekyll/docker.svg?branch=master)](https://travis-ci.org/jekyll/docker)

# Jekyll Docker Images

Jekyll Docker is a full featured Alpine based Docker image that provides an isolated Jekyll instance with the latest version of Jekyll and a bunch of nice stuff to make your life easier when working with Jekyll in both production and development.  For documentation please visit our wiki at https://github.com/jekyll/docker/wiki where you will find docs and sometimes examples.

## Image Types

There are three image types for Jekyll: `jekyll/jekyll` (standard), `jekyll/builder` (for building on a CI), and last but not least `jekyll/minimal` which is smaller and for people who don't want or need a large image with a huge amount of gems (and size to come with it.)

### Standard

The standard images (`jekyll/jekyll`) include a default set of "dev" packages, along with NodeJS, and other stuff that makes Jekyll easy.  It also includes a bunch of default gems that the community wishes us to maintain on the image.

```sh
export JEKYLL_VERSION=3.5
docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build
```

### Builder

The builer image comes with extra stuff that is not included in the standard image, like `lftp`, `openssh` and other extra packages meant to be used by people who are deploying their Jekyll builds to another server with a CI.

```sh
export JEKYLL_VERSION=3.5
docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/builder:$JEKYLL_VERSION \
  jekyll build
```

### Minimal

The minimal image skips all the extra gems, all the extra dev dependencies and leaves a very small image to download.  This is intended for people who do not need anything extra but Jekyll.

```sh
export JEKYLL_VERSION=3.5
docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/minimal:$JEKYLL_VERSION \
  jekyll build
```

## Config and Env

* `FORCE_POLLING` = `true` | `""`
* `BUNDLE_CACHE`  = `true` | `""`

## Packages

You can install system packages by providing a file named `.apk` with one package per line.  If you need to find out what the package names are for a given command you wish to use you can visit https://pkgs.alpinelinux.org. ***We provide many dependencies for most Ruby stuff by default for `builder` and standard images.  This includes `ruby-dev`, `xml`, `xslt`, `git` and other stuff that most Ruby packages might need.***

## Building Our Images

You can build our images or any specific tag of an image with `bundle exec docker-template build` or `bundle exec docker-template build repo:tag`, yes it's that simple to build our images even if it looks complicated it's not.

## Contributing

* Fork the current repo; `bundle install`
* `opts.yml` holds most of the versions, and gems.
* Test your image manually `script/boot` will help you with that.
* Ensure that your intended changes work as they're supposed to.
* Ship a pull request if you wish to have it reviewed!
