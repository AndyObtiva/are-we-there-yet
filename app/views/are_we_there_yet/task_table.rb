require 'models/are_we_there_yet/task'

class AreWeThereYet  
  class TaskTable
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
    }
    
    ## Use after_body block to setup observers for widgets in body
    #
    after_body {
    }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      table { |table_proxy|
        # TODO Make resizing table columns auto-resize form fields        
        @project_name_table_column = table_column {
          text 'Project'
          width CONFIG[:table_column_width_hint]
          editor :combo
        }
        table_column {
          text 'Type'
          width CONFIG[:table_column_width_hint]
          editor :combo
        }
        table_column {
          text 'Task'
          width CONFIG[:table_column_width_hint]
        }
        table_column {
          text 'Start Date'
          width CONFIG[:table_column_width_hint]
          editor :c_date_time, CDT::BORDER | CDT::COMPACT | CDT::DROP_DOWN | CDT::DATE_LONG, property: :start_at
        }
        table_column {
          text 'End Date'
          width CONFIG[:table_column_width_hint]
          editor :c_date_time, CDT::BORDER | CDT::COMPACT | CDT::DROP_DOWN | CDT::DATE_LONG, property: :end_at
        }
        table_column {
          text 'Duration (hours)'
          width CONFIG[:table_column_width_hint]
          editor :combo, :read_only
          sort_property :duration_in_hours
        }
        table_column {
          text 'Priority'
          width CONFIG[:table_column_width_hint]
          editor :combo, :read_only
          sort_property :priority_sort
        }
        additional_sort_properties :project_name, :task_type, :start_date, :duration_in_hours, :name, :priority_sort, :end_date
        items bind(Task, :list), column_properties(:project_name, :task_type, :name, :start_date, :end_date, :duration, :priority)
        table_proxy.sort_by_column @project_name_table_column
        
        on_control_resized {
          window_width = body_root.swt_widget.shell.bounds.width
          columns = body_root.swt_widget.columns
          new_column_width = window_width.to_f / columns.size
          columns.each do |column|
            column.width = new_column_width
          end
        }
        
        on_mouse_up { |event|
          table_proxy.edit_table_item(event.table_item, event.column_index)
        }
        
        menu {
          menu_item {
            text "Remove Task"
            on_widget_selected {
              swt_widget.selection.first.data.destroy
            }
          }
        }
      }    
    }

  end
end
