# Jekyll Docker

[![Build Status](https://travis-ci.org/jekyll/docker.svg?branch=master)][1]

Jekyll Docker is a software image that has Jekyll and many of it's dependencies ready to use for you in an encapsulated format.  It includes a default set of gems, different image types with different extra packages, and wrappers to make Jekyll run more smoothly from start to finish for most Jekyll users. If you would like to know more about Docker you can visit https://docker.com and if you would like to know more about Jekyll you can visit https://github.com/jekyll/jekyll

## Image Types

* `jekyll/jekyll`: Default image.
* `jekyll/minimal`: Very minimal image.
* `jekyll/builder`: Includes tools.

### Standard

The standard images (`jekyll/jekyll`) include a default set of "dev" packages, along with Node.js, and other stuff that makes Jekyll easy.  It also includes a bunch of default gems that the community wishes us to maintain on the image.

#### Usage

```sh
export JEKYLL_VERSION=3.5
docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build
```

### Builder

The builer image comes with extra stuff that is not included in the standard image, like `lftp`, `openssh` and other extra packages meant to be used by people who are deploying their Jekyll builds to another server with a CI.

#### Usage

```sh
export JEKYLL_VERSION=3.5
docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/builder:$JEKYLL_VERSION \
  jekyll build
```

### Docker Compose
```
version: '3'
services:
  site:
    image: jekyll/jekyll
    command: bash -c  'jekyll serve'
    working_dir: /srv/jekyll/site
    volumes:
      - .:/srv/jekyll
    ports:
      - "80:4000"
```

To setup:
`mkdir site`
`docker-compose run --workdir="/srv/jekyll" site jekyll new site`

To turn on:
`docker-compose up -d`

### Minimal

The minimal image skips all the extra gems, all the extra dev dependencies and leaves a very small image to download.  This is intended for people who do not need anything extra but Jekyll.

#### Usage

***You will need to provide a `.apk` file if you intend to use anything like Nokogiri or otherwise, we do not install any development headers or dependencies so C based gems will fail to install.***

```sh
export JEKYLL_VERSION=3.5
docker run --rm \
  --volume=$PWD:/srv/jekyll \
  -it jekyll/minimal:$JEKYLL_VERSION \
  jekyll build
```

## Config

You can configure some pieces of Jekyll using environment variables, what you cannot with environment variables you can configure using the Jekyll CLI.  Even with a wrapper, we pass all arguments onto Jekyll when we finally call it.

* `FORCE_POLLING`: `true`, `false`, `""`
* `JEKYLL_DEBUG`, `VERBOSE`: `true`, `false`, `""`
* `BUNDLE_CACHE`:`true`, `false`, `""`

If you would like to know the CLI options for Jekyll, you can visit [Jekyll's Help Site][2]

## Packages

You can install system packages by providing a file named `.apk` with one package per line.  If you need to find out what the package names are for a given command you wish to use you can visit https://pkgs.alpinelinux.org. ***We provide many dependencies for most Ruby stuff by default for `builder` and standard images.  This includes `ruby-dev`, `xml`, `xslt`, `git` and other stuff that most Ruby packages might need.***

## Building Our Images

You can build our images or any specific tag of an image with `bundle exec docker-template build` or `bundle exec docker-template build repo:tag`, yes it's that simple to build our images; even if it looks complicated it's not.

## Contributing

* Fork the current repo; `bundle install`
* `opts.yml` holds most of the versions, and gems.
* Test your image manually `script/debug` will help you with that.
* Ensure that your intended changes work as they're supposed to.
* Ship a pull request if you wish to have it reviewed!

[1]: https://travis-ci.org/jekyll/docker
[2]: http://jekyllrb.com/docs/configuration/#build-command-options
