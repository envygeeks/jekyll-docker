[![Build Status](https://travis-ci.org/jekyll/docker.svg?branch=master)](https://travis-ci.org/jekyll/docker)

# Jekyll Docker Images

Jekyll Docker is a full featured Alpine based Docker image that provides an isolated Jekyll instance with the latest version of Jekyll and a bunch of nice stuff to make your life easier when working with Jekyll in both production and development.  For documentation please visit our wiki at https://github.com/jekyll/docker/wiki where you will find docs and sometimes examples.

## Building Our Images

You can build our images or any specific tag of an image with `bundle exec docker-template build` or `bundle exec docker-template build repo:tag`, yes it's that simple to build our images even if it looks complicated it's not.

## Contributing

* Fork the current repo; `bundle install`
* `opts.yml` holds most of the versions, and gems.
* Test your image manually `script/boot` will help you with that.
* Ensure that your intended changes work as they're supposed to.
* Ship a pull request if you wish to have it reviewed!
