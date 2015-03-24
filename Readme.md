# Jekyll Docker Images

Jekyll Docker is an Ubuntu based Docker image that provides an isolated Jekyll
instance with the latest version of Jekyll, the current releases are:

* beta
* stable, latest

## Notes
  * When you launch or run anything it is run as a non-priv user jekyll in /srv/jekyll.
  * We "shiv" Jekyll to provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * Jekyll has access to sudo (mostly for the build system.)
  * Ruby is stored in /opt/jekyll bundled w/ Jekyll.

## Building

Because we have a global copy folder you need to build from the root and tell
Docker which type you want to build so replace `<TYPE>`` with stable, master or
beta and it will build that.

```sh
docker build --no-cache --force-rm -t jekyll/jekyll:<TYPE> -f <TYPE>/Dockerfile .
```

## Running

```sh
docker run --rm -v $(pwd):/srv/jekyll -p 127.0.0.1:4000:4000 \
  jekyll/jekyll:<TYPE> jekyll s
```

## Building a Deb

```sh
docker run --rm -v $(pwd):/srv/jekyll -i -t jekyll/jekyll:<TYPE> buildeb
```

## Do we Publish Debs?

Yes! We certainly do publish some of the debs, we publish stable (via this
repos release system until we have a new stable release of Jekyll) and we release
beta debs via the jekyll/jekyll release system.  We do not sign them, yet...
