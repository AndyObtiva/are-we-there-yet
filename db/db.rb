require 'active_record'
require 'activerecord-jdbcsqlite3-adapter' if defined? JRUBY_VERSION
@connection = ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/database.sqlite3')
require 'migrate' # TODO migrate only when needed
