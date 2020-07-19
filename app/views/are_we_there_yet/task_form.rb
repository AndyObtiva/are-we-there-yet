require 'models/are_we_there_yet/task'

class AreWeThereYet  
  class TaskForm
    include Glimmer::UI::CustomWidget
    
    ATTRIBUTE_COUNT = 7
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    before_body {
      @task = AreWeThereYet::Task.prototype
      @labels = {}
      @inputs = {}
    }
    
    ## Use after_body block to setup observers for widgets in body
    #
    after_body {      
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      group {
        text 'Add Task'  
        font height: 12, style: :bold
        grid_layout {
          horizontal_spacing 0
          vertical_spacing 0
          margin_width 0
          margin_height 0
        }
        composite {
          layout_data(:fill, :fill, true, true)
          grid_layout(ATTRIBUTE_COUNT, true) {
            horizontal_spacing 0
            vertical_spacing 0
            margin_width 0
            margin_height 0
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:project_name] = label {
              layout_data(:fill, :top, true, true)
              text 'Project'
            }
            @inputs[:project_name] = combo {              
              focus true             
              layout_data(:fill, :top, true, true)
              selection bind(@task, :project_name)
              on_key_pressed { |event|
                @inputs[:task_type].swt_widget.set_focus if event.keyCode == swt(:cr)
              }
            }
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:task_type] = label {
              layout_data(:fill, :top, true, true)
              text 'Type'
            }
            @inputs[:task_type] = combo {              
              layout_data(:fill, :top, true, true)
              selection bind(@task, :task_type)
              on_key_pressed { |event|
                @inputs[:name].swt_widget.set_focus if event.keyCode == swt(:cr)
              }
            }
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:name] = label {
              layout_data(:fill, :top, true, true)
              text 'Task'
            }
            @inputs[:name] = text { 
              layout_data(:fill, :top, true, true)
              text bind(@task, :name)
              on_key_pressed { |event|
                @inputs[:start_at].swt_widget.set_focus if event.keyCode == swt(:cr)
              }
            }
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:start_at] = label {
              layout_data(:fill, :top, true, true)
              text 'Start Date'
            }
            @inputs[:start_at] = c_date_time(CDT::BORDER | CDT::COMPACT | CDT::DROP_DOWN | CDT::DATE_LONG) {
              layout_data(:fill, :top, true, true)
              selection bind(@task, :start_at)
              on_key_pressed { |event|
                @inputs[:end_at].swt_widget.set_focus if event.keyCode == swt(:cr)
              }
            }
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:end_at] = label {
              layout_data(:fill, :top, true, true)
              text 'End Date'
            }
            @inputs[:end_at] = c_date_time(CDT::BORDER | CDT::COMPACT | CDT::DROP_DOWN | CDT::DATE_LONG) {
              layout_data(:fill, :top, true, true)
              selection bind(@task, :end_at)
              on_key_pressed { |event|
                @inputs[:duration].swt_widget.set_focus if event.keyCode == swt(:cr)
              }
            }
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:duration] = label {
              layout_data(:fill, :top, true, true)
              text 'Duration'
            }
            @inputs[:duration] = combo(:read_only) {
              layout_data(:fill, :top, true, true)
              selection bind(@task, :duration)
              on_key_pressed { |event|
                @inputs[:priority].swt_widget.set_focus if event.keyCode == swt(:cr)
              }
            }
          }
          composite {
            layout_data(:fill, :fill, true, true) {
              width_hint CONFIG[:table_column_width_hint] - 5
            }
            grid_layout(1, true) {
              horizontal_spacing 0
              #margin_width 0
            }
            @labels[:priority] = label {
              layout_data(:fill, :top, true, true)
              text 'Priority'
            }
            @inputs[:priority] = combo(:read_only) {
              layout_data(:fill, :top, true, true)
              selection bind(@task, :priority)
              on_key_pressed { |event|
                if event.keyCode == swt(:cr)
                  add_task
                end
              }
            }
          }
        }
        
        button {
          text 'Save Task'
          on_widget_selected {
            add_task
          }
        }
        
      }
    }
    
    def add_task
      new_task = @task.clone
      if new_task.save
        @task.reset
        @inputs[:project_name].swt_widget.set_focus
      else
        @inputs[new_task.errors.keys.first].swt_widget.set_focus
      end
      @labels.each do |attribute, label|
        label.content {
          foreground new_task.errors.keys.include?(attribute) ? :red : :black
          tool_tip_text new_task.errors.keys.include?(attribute) ? new_task.errors[attribute].first : nil
        }
      end
    end
    
  end
end
