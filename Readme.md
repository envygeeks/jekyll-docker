# Jekyll Docker Images

A set of images for building debian packages with Docker (Jekyll) and for
running Jekyll in a docker instance. There is both `:latest` and `:build` - The
build image is for building Debian packages and `:latest` is the actual Jekyll
instance you are looking for. `:build` is nothing but a public exposure of the
image used by build systems.

## Notes
  * We "shiv" Jekyll to provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.

## Running

```sh
docker run --rm \
  -v $(pwd):/srv/jekyll \
  -p 127.0.0.1:4000:4000 \
  envygeeks/jekyll:latest jekyll s
```

## Building a Deb

```sh
docker run --rm \
  -v $(pwd):/srv/jekyll envygeeks/jekyll:build buildeb
```

## Building the images

```
cd latest && docker build -t username/jekyll:latest .
```
