require 'models/are_we_there_yet/task'

class AreWeThereYet  
  class FilterForm
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
        text 'Filter Tasks'  
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
            @labels[:name_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'Task'
            }
            @inputs[:name_filter] = text { 
              layout_data(:fill, :top, true, true)
              text bind(Task, :name_filter)
              on_key_pressed { |event|
                @inputs[:project_name_filter].swt_widget.set_focus if event.keyCode == swt(:cr)
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
            @labels[:project_name_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'Project'
            }
            @inputs[:project_name_filter] = combo(:read_only) {              
              layout_data(:fill, :top, true, true)
              selection bind(Task, :project_name_filter)
              on_key_pressed { |event|
                @inputs[:task_type_filter].swt_widget.set_focus if event.keyCode == swt(:cr)
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
            @labels[:task_type_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'Type'
            }
            @inputs[:task_type_filter] = combo(:read_only) {              
              layout_data(:fill, :top, true, true)
              selection bind(Task, :task_type_filter)
              on_key_pressed { |event|
                @inputs[:start_at_filter].swt_widget.set_focus if event.keyCode == swt(:cr)
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
            @labels[:start_at_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'Start Date'
            }
            @inputs[:start_at_filter] = c_date_time(CDT::BORDER | CDT::COMPACT | CDT::DROP_DOWN | CDT::DATE_LONG) {
              layout_data(:fill, :top, true, true)
              selection bind(Task, :start_at_filter)
              on_key_pressed { |event|
                @inputs[:duration_filter].swt_widget.set_focus if event.keyCode == swt(:cr)
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
            @labels[:duration_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'Duration'
            }
            @inputs[:duration_filter] = combo(:read_only) {
              layout_data(:fill, :top, true, true)
              selection bind(Task, :duration_filter)
              on_key_pressed { |event|
                @inputs[:end_at_filter].swt_widget.set_focus if event.keyCode == swt(:cr)
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
            @labels[:end_at_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'End Date'
            }
            @inputs[:end_at_filter] = c_date_time(CDT::BORDER | CDT::COMPACT | CDT::DROP_DOWN | CDT::DATE_LONG) {
              layout_data(:fill, :top, true, true)
              selection bind(Task, :end_at_filter)
              on_key_pressed { |event|
                @inputs[:priority_filter].swt_widget.set_focus if event.keyCode == swt(:cr)
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
            @labels[:priority_filter] = label {
              layout_data(:fill, :top, true, true)
              text 'Priority'
            }
            @inputs[:priority_filter] = combo(:read_only) {
              layout_data(:fill, :top, true, true)
              selection bind(Task, :priority_filter)
            }
          }
        }

        button {
          text 'Reset Filters'
          on_widget_selected {
            Task.reset_filters
          }
        }

      }
    }
    
  end
end
