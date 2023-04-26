FROM ruby:3.0.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /todo_app
WORKDIR /todo_app

ADD Gemfile /todo_app/Gemfile
ADD Gemfile.lock /todo_app/Gemfile.lock

RUN gem install bundler --source http://rubygems.org &&\
        bundle install

RUN rails generate rspec:install


ADD . /todo_app
