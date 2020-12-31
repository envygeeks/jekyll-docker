[![Travis branch](https://img.shields.io/travis/envygeeks/jekyll-docker/master.svg?style=for-the-badge)](https://travis-ci.org/envygeeks/jekyll-docker) [![Donate](https://img.shields.io/badge/DONATE-MONEY-yellow.svg?style=for-the-badge)](https://envygeeks.io#donate) [![Docker Stars](https://img.shields.io/docker/stars/jekyll/jekyll.svg?style=for-the-badge)]() [![Docker Pulls](https://img.shields.io/docker/pulls/jekyll/jekyll.svg?style=for-the-badge)]()

# Jekyll Docker

Jekyll Docker is a software image that has Jekyll and many of its dependencies ready to use for you in an encapsulated format.  It includes a default set of gems, different image types with different extra packages, and wrappers to make Jekyll run more smoothly from start to finish for most Jekyll users. If you would like to know more about Docker you can visit https://docker.com, and if you would like to know more about Jekyll, you can visit https://github.com/jekyll/jekyll

This fork has been updated to build on Alpine3.12

## Image Types

* `jekyll/jekyll`: Default image.
* `jekyll/minimal`: Very minimal image.
* `jekyll/builder`: Includes tools.

### Standard

The standard images (`jekyll/jekyll`) include a default set of "dev" packages, along with Node.js, and other stuff that makes Jekyll easy.  It also includes a bunch of default gems that the community wishes us to maintain on the image.

#### Usage

```sh
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build
```

### Builder

The builder image comes with extra stuff that is not included in the standard image, like `lftp`, `openssh` and other extra packages meant to be used by people who are deploying their Jekyll builds to another server with a CI.

#### Usage

```sh
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/builder:$JEKYLL_VERSION \
  jekyll build
```

### Minimal

The minimal image skips all the extra gems, all the extra dev dependencies and leaves a very small image to download.  This is intended for people who do not need anything extra but Jekyll.

#### Usage

***You will need to provide a `.apk` file if you intend to use anything like Nokogiri or otherwise, we do not install any development headers or dependencies so C based gems will fail to install.***

```sh
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/minimal:$JEKYLL_VERSION \
  jekyll build
```

## Dependencies

Jekyll Docker will attempt to install any dependencies that you list inside of your `Gemfile`, matching the versions you have in your `Gemfile.lock`, including Jekyll if you have a version that does not match the version of the image you are using (you should be doing `gem "jekyll", "~> 3.8"` so that minor versions are installed if you use say image tag "3.7.3").

### Updating

If you provide a `Gemfile` and would like to update your `Gemfile.lock` you can run

```sh
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  bundle update
```

### Caching

You can enable caching in Jekyll Docker by using a `docker --volume` that points to `/usr/local/bundle` inside of the image.  This is ideal for users who run builds on CI's and wish them to be fast.

#### My Gems Aren't Caching

***If you do not diverge from the default set of gems we provide (read: add Gems to your Gemfile that aren't already on the image), then bundler by default will not create duplicates, and cache.  It will simply rely on what is already installed in `$GEM_HOME`.  This is the default (observed... but unconfirmed) behavior of `bundle` when using `$GEM_HOME` w/ `$BUNDLE_HOME`***

### Usage

```sh
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$PWD/vendor/bundle:/usr/local/bundle" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build
```
***The root of the cache volume (in this case vendor) must also be excluded from the Jekyll build via the `_config.yml` exclude array setting.***

## Configuration

You can configure some pieces of Jekyll using environment variables, what you cannot with environment variables you can configure using the Jekyll CLI.  Even with a wrapper, we pass all arguments onto Jekyll when we finally call it.

| ENV Var | Default |
|---|---|
| `JEKYLL_UID` | `1000` |
| `JEKYLL_GID` | `1000` |
| `JEKYLL_DEBUG`, | `""` |
| `VERBOSE` | `""` |
| `FORCE_POLLING` | `""` |

If you would like to know the CLI options for Jekyll, you can visit [Jekyll's Help Site][2]

## Packages

You can install system packages by providing a file named `.apk` with one package per line.  If you need to find out what the package names are for a given command you wish to use you can visit https://pkgs.alpinelinux.org. ***We provide many dependencies for most Ruby stuff by default for `builder` and standard images.  This includes `ruby-dev`, `xml`, `xslt`, `git` and other stuff that most Ruby packages might need.***

## Building

```sh
script/build
```

[1]: https://travis-ci.org/jekyll/docker
[2]: http://jekyllrb.com/docs/configuration/#build-command-options
