# Jekyll Docker Images

Jekyll Docker is an Ubuntu based Docker image that provides an isolated Jekyll
instance with the latest version of Jekyll.

## Gemfiles

This docker image supports Gemfiles.  There is nothing you need to do other than have the Gemfile in your docker root when you link it to `/srv/jekyll`, our startup script will detect the Gemfile and `gem install -g` all the gems in that file.

#### WARNING NOTE

If you do not include "jekyll" in your Gemfile sources then we will move the Gemfile to Gemfile.docker until you exit out of the image, this is because Gem does not allow you to have conflicting dependencies so we resolve this by just moving the file so that Gem can't find it allowing everything to proceed as normal.

## Running

```sh
docker run --rm -v $(pwd):/srv/jekyll -p 127.0.0.1:4000:4000 \
  jekyll/jekyll jekyll s
```

***If you do not provide a command then it will default to booting `jekyll s` for you***

## I would like to get a Gem included by default:

We only allow Jekyll gems by default, but you can fork our image and edit
copy/usr/bin/setup and add your Gem and just hit script/build and it will do
the rest for you.

## Contributing

Please do not edit the Dockerfile unless there is good reason to do so...
because of the way that Docker currently works, there are extreme space probs
in that if we install and cleanup inside of the Docker file our image
size stays the same, please edit `copy/usr/bin/setup` instead.

## Notes
  * When you launch or run anything it is run as a non-priv user jekyll in /srv/jekyll.
  * We "shiv" Jekyll to provide defaults for 0.0.0.0 and /srv/jekyll so mount to /srv/jekyll.
  * Jekyll has access to sudo (mostly for the build system.)
  * Ruby is stored in /opt/jekyll bundled w/ Jekyll.

## Building a Deb

```sh
docker run --rm -v $(pwd):/srv/jekyll -i -t jekyll/jekyll buildeb
```
