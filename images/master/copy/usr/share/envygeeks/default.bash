#!/bin/bash
cd /srv/jekyll
jekyll s &
wait $!
exit $?
