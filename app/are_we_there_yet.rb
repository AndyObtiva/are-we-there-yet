$LOAD_PATH.unshift(File.expand_path('..', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../..', __FILE__))

require 'puts_debuggerer'
require 'bundler/setup'
Bundler.require

# Load database content (or create it if it doesn't exist)
require 'db/db'

require 'vendor/nebula/org.eclipse.nebula.widgets.ganttchart_1.0.0.jar'

Glimmer::Config.import_swt_packages += [
  'org.eclipse.nebula.widgets.ganttchart',
  'org.eclipse.nebula.widgets.ganttchart.themes',
]

Glimmer::Config.logging_devices = [:stdout, :file, :syslog]
# Glimmer::Config.logger.level = 'debug'
# Glimmer::Config.logging_appender_options = Glimmer::Config.logging_appender_options.merge(async: false, auto_flushing: 1)
require 'views/are_we_there_yet/app_view'

class AreWeThereYet
  include Glimmer
  
  APP_ROOT = File.expand_path('../..', __FILE__)        
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
  
  CONFIG = {
    table_column_width_hint: 120,
  }
  
  def open
    app_view.open
  end
end
