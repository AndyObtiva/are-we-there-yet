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

  end
end
