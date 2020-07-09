require 'models/are_we_there_yet/task'

java_import 'java.util.Calendar'

java_import 'org.eclipse.nebula.widgets.ganttchart.GanttChart'
java_import 'org.eclipse.nebula.widgets.ganttchart.GanttEvent'

class AreWeThereYet
  class AppView
    include Glimmer::UI::CustomShell
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
#     option :greeting, default: 'Hello, World!'

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body {
      Display.setAppName('Are We There Yet')
      Display.setAppVersion(VERSION)
      @display = display {
        on_about {
          display_about_dialog
        }
        on_preferences {
#           display_preferences_dialog
        }
      }
    }
    
    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
      render_gantt_chart = lambda do |new_tasks|
        new_tasks.to_a.each do |task|
          gantt_event = to_gantt_event(task)
          @gantt_chart.swt_widget.addConnection(@last_gantt_event, gantt_event) if @last_gantt_event
          @last_gantt_event = gantt_event
        end
#         cpDate = Calendar.getInstance();
#         cpDate.add(Calendar::DATE, 16);        
#         eventThree = GanttEvent.new(@gantt_chart.swt_widget, "Checkpoint", cpDate, cpDate, 75);
#         eventThree.setCheckpoint(true);        
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
        minimum_size 320, 240
        text "Are We There Yet - App View"
        grid_layout {
          margin_width 5
          margin_height 5
          horizontal_spacing 5
          vertical_spacing 5
        }
        sash_form(:vertical) {
          layout_data(:fill, :fill, true, true)
          composite {
            @gantt_chart = gantt_chart {
              layout_data(:fill, :fill, true, true) {
                minimum_height 200
              }
            }
          }
          composite {
            composite {
              grid_layout 6, true
              composite {
                layout_data(:fill, :fill, true, true) {
                  width_hint 115
                }
                fill_layout :vertical
                label {
                  text 'Task'
                }
                text {              
                }
              }
              composite {
                layout_data(:fill, :fill, true, true) {
                  width_hint 115
                }
                fill_layout :vertical
                label {
                  text 'Project'
                }
                text {              
                }
              }
              composite {
                layout_data(:fill, :fill, true, true) {
                  width_hint 115
                }
                fill_layout :vertical
                label {
                  text 'Type'
                }
                text {              
                }
              }
              composite {
                layout_data(:fill, :fill, true, true) {
                  width_hint 115
                }
                fill_layout :vertical
                label {
                  text 'Start Date/Time'
                }
                text {              
                }
              }
              composite {
                layout_data(:fill, :fill, true, true) {
                  width_hint 115
                }
                fill_layout :vertical
                label {
                  text 'Duration'
                }
                text {              
                }
              }
              composite {
                layout_data(:fill, :fill, true, true) {
                  width_hint 115  
                }
                fill_layout :vertical
                label {
                  text 'Priority'
                }
                text {
                  on_key_pressed { |event|
                    if event.keyCode == swt(:cr)
                      AreWeThereYet::Task.create!(
                        project_name: 'MVP',
                        name:         "Create task",
                        task_type:    'Development',
                        start_at:     Time.now,
                        duration:     3,
                        priority:     'High',
                        position:     3
                      )
                    end
                  }
                }
              }
            }
            table {
              layout_data :fill, :fill, true, true
              table_column {
                text 'Task'
                width 120
              }
              table_column {
                text 'Project'
                width 120
              }
              table_column {
                text 'Type'
                width 120
              }
              table_column {
                text 'Start Date/Time'
                width 120
              }
              table_column {
                text 'Duration (hours)'
                width 120
              }
              table_column {
                text 'Priority'
                width 120
              }
              items bind(Task, :all, on_read: :to_a), column_properties(:name, :project_name, :task_type, :start_at, :duration, :priority)
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
      dialog(swt_widget) {
        text 'Preferences'
        grid_layout {
          margin_height 5
          margin_width 5
        }
        group {
          row_layout {
            type :vertical
            spacing 10
          }
          text 'Greeting'
          font style: :bold
          [
            'Hello, World!', 
            'Howdy, Partner!'
          ].each do |greeting_text|
            button(:radio) {
              text greeting_text
              selection bind(self, :greeting) { |g| g == greeting_text }
              layout_data {
                width 160
              }
              on_widget_selected { |event|
                self.greeting = event.widget.getText
              }
            }
          end
        }
      }.open
    end
    
    def to_gantt_event(task)
      start_date_time = Calendar.getInstance # TODO move to Task class
      start_date_time.set(task.start_at.year, task.start_at.month, task.start_at.day, task.start_at.hour, task.start_at.min, task.start_at.sec)
      end_date_time = Calendar.getInstance # TODO move to Task class
      end_date_time.set(task.end_at.year, task.end_at.month, task.end_at.day, task.end_at.hour, task.end_at.min, task.end_at.sec)         
      GanttEvent.new(@gantt_chart.swt_widget, task.name, start_date_time, end_date_time, task.finished? ? 100 : 0) # TODO support percent complete
    end
    
  end
end
