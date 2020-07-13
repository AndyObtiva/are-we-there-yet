require 'views/are_we_there_yet/gantt_chart_settings'

class AreWeThereYet
  class PreferencesDialog
    include Glimmer::UI::CustomShell
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    options :parent_shell_proxy, :current_settings
    
    attr_reader :gantt_chart_settings

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body {
      @gantt_chart_settings = GanttChartSettings.new(current_settings)
    }

    ## Use after_body block to setup observers for widgets in body
    #
    # after_body {
    # 
    # }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      shell(parent_shell_proxy.swt_widget, :shell_trim) {
        minimum_size 1024, 768
        text 'Preferences'
        grid_layout 1, false
        scrolled_composite(:h_scroll, :v_scroll) { |scrolled_composite_proxy|     
          layout_data(:fill, :fill, true, true)
          @group_proxy = group {
            text 'Gantt Chart Settings'
            font height: 16, style: :bold
            grid_layout 2, true
            GanttChartSettings::SETTINGS_BOOLEAN.each do |setting|
              composite {
                row_layout :horizontal
                button(:check) {
                  selection bind(@gantt_chart_settings, setting)
                  on_widget_selected { |event|
                    Task.notify_observers('all')
                  }
                }
                label {
                  text setting.underscore.gsub('_', ' ').capitalize
                }
              }
            end
          }
          
          scrolled_composite_proxy.swt_widget.set_content @group_proxy.swt_widget
          scrolled_composite_proxy.swt_widget.set_expand_horizontal true
          scrolled_composite_proxy.swt_widget.set_expand_vertical true
          scrolled_composite_proxy.swt_widget.set_min_size 1024, 356
        }
      }
    }
  end
end
