# Premium Finder

This project contains the Premium Finder, in which you can
search for Merchants, Stores that sell PREMIUM products and
speaker for PREMIUM.

[Visit the map!](https://premiumc.cygnus.uberspace.de/maps/embed "Premium Finder")

## Setting it up

### Docker

We provide a [docker container](https://github.com/premium-cola/premium-map) for testing the application.
Using it should be very straight forward. 

### Manual Way

Clone the repository, then change into it's directory and
run:

```bash
  $ apt-get install ruby1.9.1-dev build-essential g++ libmysql-ruby libmysqlclient-dev libsqlite3-dev mysql
  $ gem install bundler
  $ bundle install
  $ bundle exec rake db:reset
  $ bundle exec unicorn -l 127.0.0.1:3000
```

_(apt-get install has to be run as root)_


You should now be able to visit the application:
http://localhost:3000
To visit the actual maps: http://localhost:3000/maps/embed

You can logi

We are using very old gems here. If you run into problems
finding some of the very old ones, they should be provided
int the docker container's repo.

## Credits

* Karolin Varner <karo@cupdev.net> (*active*)
* Bodo Tasche <bodo.tasche@gmail.com> (inactive)
* Nelson Darkwah Oppong <ndo@felixnelson.de> (inactive)

Thanks!

# COPYRIGHT

Copyright 2014 by Karolin Varner <karo@cupdev.net>
Copyright 2013-2014 by Bodo Tasche <bodo.tasche@gmail.com>
Copyright 2013-2014 by Nelson Darkwah Oppong <ndo@felixnelson.de> 

This project was created on behalf of
[PREMIUM](http://www.premium-cola.de/).

The contents of this repository are licensed under the GPL
license version three or higher version.

In addition to the terms of the GPL license, any Authors of
this project and PREMIUM must be named in derivatives of
this Software.
Neither any authors nor PREMIUM my be named in order to
endorse any product based on the work in this repository.

See the COPYING file for a copy of the GPLv3 license.
