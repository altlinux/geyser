# Welcome to Geyser

[![Build Status](https://api.travis-ci.com/altlinux/geyser.png?branch=master)](https://travis-ci.com/altlinux/geyser.png)
[![Code Climate](https://codeclimate.com/github/altlinux/geyser/badges/gpa.svg)](https://codeclimate.com/github/altlinux/geyser)
[![Test Coverage](https://codeclimate.com/github/caltlinux/geyse/badges/coverage.svg)](https://codeclimate.com/github/altlinux/geyser)
[![MIT License](http://b.repl.ca/v1/License-MIT-blue.png)](LICENSE)

## Setup and run

### Installation

* Ruby 2.5.1
* Bundler 1.16.2
* PostgreSQL 9.6 (some features will not work in other db)
* nginx
* gettext
* node.js
* /usr/bin/md5sum from coreutils
* git
* memcached
* rpm
* rpm2cpio
* bzip2
* GNU coreutils
* GNU cpio

or with a few lines:

    # apt-get install postgresql11-server postgresql11-contrib postgresql11 bzip2 \
                      gettext memcached /usr/bin/md5sum npm nodejs \
                      libruby-devel ruby zlib-devel postgresql11-devel ruby-bundler

### Post setup

    # service postgresql start
    $ memcached -d -m 128
    $ bundle install
    $ rake secret
    $ rake gettext:pack

### Initialize the database

    $ bundle exec rails db:create db:migrate db:seed

### Import data

    $ rake update:branches update:lost[true]


## Deployment

    $ cap production deploy

or from the specific branch/tag:

    $ BRANCH=0.3 cap production deploy

## Tests

    $ rspec

## Useful links

https://github.com/shieldfy/API-Security-Checklist

## License

Geyser uses the MIT license. Please check the MIT-LICENSE file for more details.

## Some things

Q: How to know able to build?

A:

    $ ssh build.alt task new --help|grep Valid|sed 's|.*: ||'
