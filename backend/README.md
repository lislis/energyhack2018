# Backend

This is a simple Sinatra app with an (as of right now) in-memory sqlite data base.

It exposes a few endpoints documented on the `/` route.

## Run it locally

Have ruby 2.5.1 and bundler installed.

``` bash
$ bundle install
```

to install dependencies.

For **development** I used Shotgun as a server.
Shotgun restarts the server after every request. Handy if you change the server side code a lot.
In `config.ru` comment out the 1st line and comment in the 2nd line.

Run `$ bundle exec shotgun` to start the dev server.

For **production** server purposes, use Thin.
In `config.ru` comment in the 1st line and comment out the 2nd line.

Run `$ bundle exec thin start` to start the server.

## Todo

- extract database code into seperate file,
- create sqlite database file
