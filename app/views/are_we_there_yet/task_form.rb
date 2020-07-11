require 'models/are_we_there_yet/task'

java_import 'java.util.Calendar'

class AreWeThereYet  
  class TaskForm
    include Glimmer::UI::CustomWidget
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body {
      @task = AreWeThereYet::Task.new
    }
    
    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
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
          @task_text = text {              
            on_key_pressed { |event|
              @project_name_text.swt_widget.set_focus if event.keyCode == swt(:cr)
            }
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
          @project_name_text = combo {              
            selection bind(@task, :project_name)
            on_key_pressed { |event|
              @task_type_text.swt_widget.set_focus if event.keyCode == swt(:cr)
            }
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
          @task_type_text = combo {              
            selection bind(@task, :task_type)
            on_key_pressed { |event|
              @start_date_time_text.swt_widget.set_focus if event.keyCode == swt(:cr)
            }
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
          @start_date_time_text = text {              
            on_key_pressed { |event|
              @duration_text.swt_widget.set_focus if event.keyCode == swt(:cr)
            }
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
          @duration_text = combo(:read_only) {
            selection bind(@task, :duration)
            on_key_pressed { |event|
              @priority_text.swt_widget.set_focus if event.keyCode == swt(:cr)
            }
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
          @priority_text = combo(:read_only) {
            selection bind(@task, :priority)
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
    }

  end
end
