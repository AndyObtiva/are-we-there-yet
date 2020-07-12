require 'models/are_we_there_yet/task'
require 'views/are_we_there_yet/gantt_chart_settings'
require 'views/are_we_there_yet/task_form'
require 'views/are_we_there_yet/task_table'
require 'views/are_we_there_yet/preferences_dialog'

java_import 'java.util.Calendar'

class AreWeThereYet  
  class AppView        
    include Glimmer::UI::CustomShell
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body {
      Display.setAppName('Are We There Yet?')
      Display.setAppVersion(VERSION)
      @display = display {
        on_about {
          display_about_dialog
        }
        on_preferences {
          display_preferences_dialog
        }
      }
      @gantt_chart_settings = GanttChartSettings.new
    }
    
    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
      render_gantt_chart = lambda do |new_tasks|
        @gantt_chart.swt_widget.dispose
        @gantt_chart_container.content {
          @gantt_chart = gantt_chart(GanttFlags::H_SCROLL_FIXED_RANGE, @gantt_chart_settings) {
            layout_data(:fill, :fill, true, true) {
              minimum_height 200
            }
          }          
        }
        @last_gantt_event = nil  
        new_tasks.to_a.each do |task|
          gantt_event = to_gantt_event(task)
          if @last_gantt_event
            @last_gantt_event.setCheckpoint(false)
            @gantt_chart.swt_widget.addConnection(@last_gantt_event, gantt_event)
          end
          @last_gantt_event = gantt_event
        end
      end
      observe(Task, :all, &render_gantt_chart) 
      render_gantt_chart.call(Task.all)
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      shell {
        # Replace example content below with custom shell content
        minimum_size 750, 550
        text "Are We There Yet?"
        grid_layout {
          margin_width 5
          margin_height 5
          horizontal_spacing 5
          vertical_spacing 5
        }
        sash_form(:vertical) {
          layout_data(:fill, :fill, true, true)
          @gantt_chart_container = composite { |container|
            @gantt_chart = gantt_chart(GanttFlags::H_SCROLL_FIXED_RANGE, @gantt_chart_settings) {
              layout_data(:fill, :fill, true, true) {
                minimum_height 200
              }
            }
          }
          composite {
            task_form {
              layout_data :fill, :fill, true, true            
            }
            task_table {
              layout_data :fill, :fill, true, true
            }
          }
        }
      }
    }

    def display_about_dialog
      message_box = MessageBox.new(swt_widget)
      message_box.setText("About")
      message = "Are We There Yet - App View #{VERSION}"
      message += LICENSE
      message_box.setMessage(message)
      message_box.open
    end
    
    def display_preferences_dialog        
      preferences_dialog(parent_shell_proxy: body_root).open
    end
    
    def to_gantt_event(task)
      start_date_time = Calendar.getInstance # TODO move to Task class
      start_date_time.set(task.start_at.year, task.start_at.month, task.start_at.day, task.start_at.hour, task.start_at.min, task.start_at.sec)
      end_date_time = Calendar.getInstance # TODO move to Task class
      end_date_time.set(task.end_at.year, task.end_at.month, task.end_at.day, task.end_at.hour, task.end_at.min, task.end_at.sec)         
      gantt_event = GanttEvent.new(@gantt_chart.swt_widget, task.name, start_date_time, end_date_time, task.finished? ? 100 : 0) # TODO support percent complete
      gantt_event.setCheckpoint(true)
      gantt_event
    end
    
  end
end
