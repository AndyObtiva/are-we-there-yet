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
      @labels = {}
      @texts = {}
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
          @labels[:name] = label {
            text 'Task'
          }
          @texts[:name] = text { 
            focus true             
            text bind(@task, :name)
            on_key_pressed { |event|
              @texts[:project_name].swt_widget.set_focus if event.keyCode == swt(:cr)
            }
          }
        }
        composite {
          layout_data(:fill, :fill, true, true) {
            width_hint 115
          }
          fill_layout :vertical
          @labels[:project_name] = label {
            text 'Project'
          }
          @texts[:project_name] = combo {              
            selection bind(@task, :project_name)
            on_key_pressed { |event|
              @texts[:task_type].swt_widget.set_focus if event.keyCode == swt(:cr)
            }
          }
        }
        composite {
          layout_data(:fill, :fill, true, true) {
            width_hint 115
          }
          fill_layout :vertical
          @labels[:task_type] = label {
            text 'Type'
          }
          @texts[:task_type] = combo {              
            selection bind(@task, :task_type)
            on_key_pressed { |event|
              @texts[:start_at].swt_widget.set_focus if event.keyCode == swt(:cr)
            }
          }
        }
        composite {
          layout_data(:fill, :fill, true, true) {
            width_hint 115
          }
          fill_layout :vertical
          @labels[:start_at] = label {
            text 'Start Date/Time'
          }
          @texts[:start_at] = text {              
            on_key_pressed { |event|
              @texts[:duration].swt_widget.set_focus if event.keyCode == swt(:cr)
            }
          }
        }
        composite {
          layout_data(:fill, :fill, true, true) {
            width_hint 115
          }
          fill_layout :vertical
          @labels[:duration] = label {
            text 'Duration'
          }
          @texts[:duration] = combo(:read_only) {
            selection bind(@task, :duration)
            on_key_pressed { |event|
              @texts[:priority].swt_widget.set_focus if event.keyCode == swt(:cr)
            }
          }
        }
        composite {
          layout_data(:fill, :fill, true, true) {
            width_hint 115  
          }
          fill_layout :vertical
          @labels[:priority] = label {
            text 'Priority'
          }
          @texts[:priority] = combo(:read_only) {
            selection bind(@task, :priority)
            on_key_pressed { |event|
              if event.keyCode == swt(:cr)
                @task.start_at = Time.now
                new_task = @task.clone
                if new_task.save
                  @task.reset
                  @texts[:name].swt_widget.set_focus
                else
                  @texts[new_task.errors.keys.first].swt_widget.set_focus
                end
                @labels.each do |attribute, label|
                  label.content {
                    foreground new_task.errors.keys.include?(attribute) ? :red : :black
                    tool_tip_text new_task.errors.keys.include?(attribute) ? new_task.errors[attribute].first : nil
                  }
                end
              end
            }
          }
        }
      }
    }
    
  end
end
