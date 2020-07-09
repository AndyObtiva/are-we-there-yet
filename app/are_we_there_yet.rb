$LOAD_PATH.unshift(File.expand_path('..', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../db', __FILE__))

require 'puts_debuggerer'
require 'bundler/setup'
Bundler.require

require 'db'
require 'views/are_we_there_yet/app_view'

class AreWeThereYet
  include Glimmer

  APP_ROOT = File.expand_path('../..', __FILE__)        
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
            
  def open
    app_view.open
  end
end
