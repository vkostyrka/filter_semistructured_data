# README

#### How to setup and run
To run this project you need

##### Install ruby
Required version of Ruby version 2.7.0
You can use rvm for that https://rvm.io/rvm/install. Than install needed version and use ti for that folder:

    rvm install ruby-2.7.0
    rvm use ruby-2.7.0

##### Install PostgreSQL
[official site](https://www.postgresql.org/download/). You need to create database and user:

    sudo -u postgres createdb filter_semistructured_data_development
    sudo -u postgres createdb filter_semistructured_data_test
    sudo -u postgres createuser --interactive


##### Install dependencies
1. install all gems `bundle install`
2. install yarn version 1.12.3
3. install all yarn packages `yarn`
4. migrate database `rake db:create db:migrate`
