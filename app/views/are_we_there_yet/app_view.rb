require 'models/are_we_there_yet/task'
require 'models/are_we_there_yet/gantt_chart_settings'
require 'views/are_we_there_yet/task_form'
require 'views/are_we_there_yet/filter_form'
require 'views/are_we_there_yet/task_table'
require 'views/are_we_there_yet/preferences_dialog'

java_import 'java.util.Calendar'

class AreWeThereYet  
  class AppView        
    include Glimmer::UI::CustomShell
    
    GANTT_CHART_MINIMUM_HEIGHT = 297
    
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
          display_about_dialog
#           display_preferences_dialog
        }
      }
      @gantt_chart_settings = GanttChartSettings.new
      @mutex = Mutex.new
    }
    
    ## Use after_body block to setup observers for widgets in body
    #
    after_body {      
      render_gantt_chart = lambda do |new_tasks|
        @gantt_chart.swt_widget.dispose
        @gantt_chart_container.content {
          @gantt_chart = gantt_chart(GanttFlags::H_SCROLL_INFINITE, @gantt_chart_settings) {
            on_events_moved(&method(:handle_event_change))
            on_events_resize_finished(&method(:handle_event_change))
          }
        }
        @gantt_chart_container.swt_widget.set_content @gantt_chart.swt_widget
        @last_gantt_event = {}
        new_tasks.to_a.group_by(&:project_name).each do |project_name, project_tasks|
          @last_gantt_event[project_name] = nil # TODO turn this into a project_name hash
          gantt_section = GanttSection.new(@gantt_chart.swt_widget, project_name)
          project_tasks.each do |task|
            gantt_event = to_gantt_event(task)
            gantt_section.add_gantt_event(gantt_event)
            if @last_gantt_event[project_name]
              @gantt_chart.swt_widget.addConnection(@last_gantt_event[project_name], gantt_event)
            end
            @last_gantt_event[project_name] = gantt_event
          end
        end
      end
      observe(Task, :chart, &render_gantt_chart)
      render_gantt_chart.call(Task.chart)
      @after_body_done = true
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      shell {
        # Replace example content below with custom shell content
        minimum_size 750, 750
        text "Are We There Yet?"
        image(File.join('..', 'Are We There Yet.ico')) if OS.windows? # retrieves it from installation directory on Windows
        on_swt_show {
          swt_widget.set_bounds 0, 0, @display.monitors.first.bounds.width, @display.monitors.first.bounds.height
        }
        grid_layout {
          margin_width 5
          margin_height 5
          horizontal_spacing 5
          vertical_spacing 5
        }
        sash_form(:vertical) {
          layout_data(:fill, :fill, true, true)
          sash_width 10          
          @gantt_chart_container = scrolled_composite { |container|
            @gantt_chart = gantt_chart(GanttFlags::H_SCROLL_INFINITE, @gantt_chart_settings)
          }
          composite { |composite_proxy|
            task_form {
              layout_data(:fill, :fill, true, true) {
                minimum_height 120
              }
            }
            filter_form {
              layout_data(:fill, :fill, true, true) {
                minimum_height 120
              }
            }
          }
          @task_table = task_table {
            layout_data :fill, :fill, true, true
          }
          weights [13, 8, 11]
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
    
    def handle_event_change(events, mouse_event)
      handler = lambda do
        @mutex.synchronize do
          @gantt_chart_rendering_pending = true
          gantt_event = events.first
          task = gantt_event.data
          original_start_at = task.start_at
          original_end_at = task.end_at
          task.start_at = Time.at(gantt_event.revised_start.time_in_millis / 1000.0) if gantt_event.revised_start
          task.end_at = Time.at(gantt_event.revised_end.time_in_millis / 1000.0) if gantt_event.revised_end
          if gantt_event.revised_end.nil?
            task.duration_time = original_end_at - task.start_at
          end    
        end
      end
      
      handler_count = @handler_count = @handler_count.to_i + 1
      if mouse_event.count == 0
        Thread.new {
          sleep(0.50)
          async_exec {
            if @handler_count == handler_count
              handler.call
              @handler_count = nil
            end
          }
        }
      else
        handler.call
        @handler_count = nil
      end
    end
    
    def to_gantt_event(task)
      start_date_time = Calendar.getInstance # TODO move to Task class
      start_date_time.set(task.start_at.year, task.start_at.month - 1, task.start_at.day, task.start_at.hour, task.start_at.min, task.start_at.sec)
      end_date_time = Calendar.getInstance # TODO move to Task class
      end_date_time.set(task.end_at.year, task.end_at.month - 1, task.end_at.day, task.end_at.hour, task.end_at.min, task.end_at.sec)         
      gantt_event = GanttEvent.new(@gantt_chart.swt_widget, task.name, start_date_time, end_date_time, task.finished? ? 100 : 0) # TODO support percent complete
      gantt_event.data = task
      gantt_event
    end
    
  end
end
