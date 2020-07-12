$LOAD_PATH.unshift(File.expand_path('..', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../..', __FILE__))

require 'puts_debuggerer'
require 'bundler/setup'
Bundler.require

require 'db/db'

require 'vendor/nebula/org.eclipse.nebula.cwt_1.1.0.jar'
require 'vendor/nebula/org.eclipse.nebula.widgets.cdatetime_1.4.0.jar'
require 'vendor/nebula/org.eclipse.nebula.widgets.ganttchart_1.0.0.jar'

Glimmer::Config.import_swt_packages += [
  'org.eclipse.nebula.cwt',
  'org.eclipse.nebula.widgets.cdatetime',
  'org.eclipse.nebula.widgets.ganttchart',
]

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
