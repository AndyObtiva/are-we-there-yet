$LOAD_PATH.unshift(File.expand_path('..', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../..', __FILE__))

require 'glimmer-dsl-swt'

class AreWeThereYet
  class Splash
    include Glimmer

    class << self
      attr_reader :shell_proxy

      def open
        sync_exec {
          @shell_proxy = shell(:no_trim, :on_top) {
            minimum_size 128, 128
            background :transparent
            background_image File.expand_path(File.join('..', '..', 'are-we-there-yet-logo.png'), __FILE__)
            cursor display.swt_display.get_system_cursor(swt(:cursor_appstarting))
          }
          @shell_proxy.open
        }
      end

      def close
        sync_exec {
          @shell_proxy&.swt_widget&.close
        }
      end
    end
  end

end

Thread.new do
  AreWeThereYet::Splash.open
end


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
