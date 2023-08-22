# README

This Employee Data Tech Challenge is built using Ruby on Rails. 

### Setup
To run this application locally, you must have the following versions of Ruby and Rails installed:

* Ruby version
  3.1.2

* Rails version
  7.0.7

See [Rails Guide, Getting Started, Installing Rails](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails) for directions to install Ruby and Rails, necessary. Additionally, if you are having a trouble with installing the correct version of ruby, you may want to use a ruby version manager, [rbenv](https://github.com/rbenv/rbenv#readme)

Database creation is not necessary for this app

Access token caching:
  The access token is stored using [Rails low level caching](https://guides.rubyonrails.org/caching_with_rails.html#low-level-caching).

### Local deployment
  * From a terminal, in the app directory, run `bin/rails server`.
  * You should see output in the terminal that includes `Listening on http://[::1]:3000`
  * In a browser window, navigate to localhost:3000.
  * You should see a list of providers.

