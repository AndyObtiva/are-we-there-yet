# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'glimmer-dsl-swt', '~> 4.17.5.0' #, path: '../glimmer-dsl-swt'
gem 'glimmer-cw-cdatetime-nebula', '~> 1.5.0.1.0' #, path: '../glimmer-cw-cdatetime'
gem 'activerecord', '~> 5.2.4.3'
gem 'activerecord-jdbcsqlite3-adapter', '~> 52.6', :platform => :jruby

group :development do
  gem 'glimmer-cs-gladiator'
  gem 'jeweler'
  gem 'warbler'
end

group :test do
  gem 'rspec'
end
