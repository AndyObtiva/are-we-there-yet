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
  'org.eclipse.nebula.widgets.ganttchart.themes',
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
    configure_table_proxy
    app_view.open
  end
  
  def configure_table_proxy
    Glimmer::SWT::TableProxy.editors[:c_date_time] ||= {
      widget_value_property: :selection,
      editor_gui: lambda do |args, model, property, table_proxy|      
        args << CDT::DROP_DOWN if args.empty?
        table_editor_widget_proxy = c_date_time(*args) {
          table_proxy.table_editor.minimumHeight = 20
          selection model.send(property)
          focus true
          on_focus_lost {
            table_proxy.finish_edit!
          }
          on_key_pressed { |key_event|
            if key_event.keyCode == swt(:cr)
              table_proxy.finish_edit!
            elsif key_event.keyCode == swt(:esc)
              table_proxy.cancel_edit!
            end
          }
          on_widget_selected { |event|
            table_proxy.finish_edit!
          }
          on_widget_default_selected { |event|
            table_proxy.finish_edit!
          }
        }
        table_editor_widget_proxy
      end
    }
  end
end
