# Young Rewired State Hacks [![Build Status](https://travis-ci.org/rewiredstate/hacks.png?branch=master)](https://travis-ci.org/rewiredstate/hacks)

A database for hacks and creations at Young Rewired State events.

This is a fork of [the existing app for Rewired State projects](https://github.com/rewiredstate/hacks).
It's a Rails 4 app, using PostgreSQL to store data.

## Configuration

Screenshot uploads in the production environment are using Amazon S3 at present,
so you'll need to set your credentials and bucket in the environment:

    export S3_KEY=<key>
    export S3_SECRET=<secret>
    export S3_BUCKET=<bucket>

(on Heroku these can be set with `heroku config:add S3_KEY=<key>`)

You can create an admin user with the Rake task:

    $ bundle exec rake admin:create[example@example.com,abcdefhi]
    => Created admin user example@example.com

## Getting Started

The easiest way to run the application in development.

    bundle install
    bin/rake db:setup
    bin/rails s

## Testing

We're using RSpec for testing. To run all the tests:

    bin/rake

You'll need to ensure you have PhantomJS installed for the feature specs to run.
If you have Homebrew installed, `brew install phantomjs` will set it up for you.

## Colophon

* Award icons from [Farm-Fresh](http://www.fatcow.com/free-icons)

## Contributors

* [Jordan Hatch](http://jordanh.net/)
* [Adam McGreggor](http://blog.amyl.org.uk/)

## License

MIT License
