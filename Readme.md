# Jekyll Docker Images

Jekyll Docker is a set of images that provide Jekyll in an instance and a build
script for Ubuntu to build a deb if it pleases you (Fedora/openSUSE/Arch tba.)

## Notes
  * When you launch or run anything it is run as a non-priv user jekyll in /srv/jekyll.
  * We "shiv" Jekyll to provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * Jekyll has access to sudo (mostly for the build system.)
  * Ruby is stored in /opt/jekyll bundled w/ Jekyll.

## Running

```sh
docker run --rm -v $(pwd):/srv/jekyll -p 127.0.0.1:4000:4000 \
  jekyll/jekyll:stable jekyll s
```

## Building a Deb

```sh
docker run --rm -v $(pwd):/srv/jekyll -i -t jekyll/jekyll:beta   buildeb
docker run --rm -v $(pwd):/srv/jekyll -i -t jekyll/jekyll:stable buildeb
```
