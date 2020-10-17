$LOAD_PATH.unshift(File.expand_path('..', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../..', __FILE__))

require 'puts_debuggerer'
require 'bundler'
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

Glimmer::SWT::WidgetProxy::DEFAULT_INITIALIZERS['c_date'] = Glimmer::SWT::WidgetProxy::DEFAULT_INITIALIZERS['c_date_compact'] = Glimmer::SWT::WidgetProxy::DEFAULT_INITIALIZERS['c_date_spinner'] = Glimmer::SWT::WidgetProxy::DEFAULT_INITIALIZERS['c_date_drop_down'] = lambda do |widget|
  has_pattern_style = %w[time_short time_medium date_short date_medium date_long].reduce(false) {|result, style| result || widget.get_data('proxy').has_style?(style)}
  unless has_pattern_style
    widget.format = Glimmer::SWT::CDTProxy[:date_short]
    widget.pattern = 'yyyy-MM-dd'
  end
end

require 'views/are_we_there_yet/app_view'

class AreWeThereYet
  include Glimmer
  
  APP_ROOT = File.expand_path('../..', __FILE__)        
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
  APP_INSTALLED_ICON = File.join('..', 'Are We There Yet.ico')
  APP_ICON = File.join(APP_ROOT, 'package', 'windows', 'Are We There Yet.ico')
  
  CONFIG = {
    table_column_width_hint: 120,
  }
  
  def open
    sync_exec {
      @app_view = app_view # loads app view while splash screen is still showing
      AreWeThereYet::Splash.close      
      @app_view.open
    }
  end
end
