# README

#### How to setup and run
To run this project you need

##### Install ruby
Required version of Ruby version 2.6.2
You can use rvm for that https://rvm.io/rvm/install. Than install needed version and use ti for that folder:

    rvm install ruby-2.6.2
    rvm use ruby-2.6.2

##### Install PostgreSQL
[official site](https://www.postgresql.org/download/). You need to create database and user:

    sudo -u postgres createdb universal_parser_development
    sudo -u postgres createdb universal_parser_test
    sudo -u postgres createuser --interactive


##### Install dependencies
1. install all gems `bundle install`
2. install yarn version 1.12.3
3. install all yarn packages `yarn`
4. migrate database `rake db:create db:migrate`
