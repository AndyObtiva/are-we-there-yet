require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'glimmer/launcher'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "are_we_there_yet"
  gem.homepage = "http://github.com/AndyObtiva/are_we_there_yet"
  gem.license = "MIT"
  gem.summary = %Q{Small Project Tracking Desktop App}
  gem.description = %Q{Small Project Tracking Desktop App built with Glimmer}
  gem.email = "andy.am@gmail.com"
  gem.authors = ["Andy Maleh"]
  gem.files = Dir['Rakefile', 'Gemfile', 'Gemfile.lock', '*.png', '*.gif', 'Jars.lock', 'README.md', 'LICENSE.txt', 'VERSION', 'bin/**/*', 'app/**/*', 'vendor/**/*', 'icons/**/*', 'package/**/*']
  gem.require_paths = ['bin']
  gem.executables = []
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

## Use the following configuration if you would like to customize javapackager
## arguments for `glimmer package` command.
#
require 'glimmer/rake_task'
Glimmer::RakeTask::Package.javapackager_extra_args =
 " -native #{ENV['NATIVE'] || ('dmg' if OS.mac?) || ('msi' if OS.windows?)}"
#   " -BlicenseType=" +
#   " -Bmac.CFBundleIdentifier=" +
#   " -Bmac.category=" +
#   " -Bmac.signing-key-developer-id-app="
