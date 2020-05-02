# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'carrierwave', '2.0.2'
gem 'devise', '4.7.1'
gem 'haml-rails', '2.0.1'
gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'pry-rails', '0.3.9'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
gem 'rubocop', '0.78.0'
gem 'rubocop-rails', '2.4.0'
gem 'sass-rails', '>= 6'
gem 'simple_form', '5.0.2'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '3.9.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
