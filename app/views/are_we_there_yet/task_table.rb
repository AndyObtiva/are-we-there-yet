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
      table(:multi) { |table_proxy|
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
        
        on_menu_detected { |event|
          column_x = event.x - event.widget.shell.bounds.x
          column_y = 0
          @column_index = nil
          # TODO offload this to a method on TableProxy
          @sort_by_menu_item.swt_widget.text = 'Sort'
          @remove_task_menu_item.swt_widget.text = 'Remove Task'
          if !event.widget.items.empty?
            @remove_task_menu_item.swt_widget.text = 'Remove Tasks' if swt_widget.selection.size > 1
            table_item = event.widget.items.first
            @column_index = event.widget.column_count.times.to_a.detect do |ci|
              table_item.getBounds(ci).contains(column_x, column_y)
            end
            @sort_by_menu_item.swt_widget.text = "Sort by #{swt_widget.columns[@column_index].text}" if @column_index
          end
        }
        
        menu {
          @remove_task_menu_item = menu_item {
            text "Remove Task"
            on_widget_selected {
              swt_widget.selection.map(&:data).each(&:destroy)
            }
          }
          @sort_by_menu_item = menu_item {            
            text 'Sort'
            on_widget_selected { |event|
              body_root.sort_by_column(body_root.table_column_proxies[@column_index]) if @column_index
            }
          }
        }
      }    
    }

  end
end
