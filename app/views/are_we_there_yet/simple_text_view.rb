require 'models/are_we_there_yet/task'

class AreWeThereYet
  class SimpleTextView
    include Glimmer::UI::CustomWidget

    ## Add options like the following to configure CustomWidget by outside consumers
    #
    # options :custom_text, :background_color
    # option :foreground_color, default: :red

    ## Use before_body block to pre-initialize variables to use in body
    #
    #
    # before_body {
    # 
    # }

    ## Use after_body block to setup observers for widgets in body
    #
    # after_body {
    # 
    # }

    ## Add widget content under custom widget body
    ##
    ## If you want to add a shell as the top-most widget, 
    ## consider creating a custom shell instead 
    ## (Glimmer::UI::CustomShell offers shell convenience methods, like show and hide)
    #
    body {
      # Replace example content below with custom widget content
      styled_text(:multi, :border, :h_scroll, :v_scroll) {              
        text bind(Task, :list, read_only: true) { |tasks|
          tasks.to_a.group_by(&:project_name).reduce({}) do |hash, project|
            project_name, project_tasks = project
            hash.merge(project_name => project_tasks.group_by(&:task_type))
          end.map do |project_name, project_task_grouping|            
            "# #{project_name}\n" + project_task_grouping.map do |task_type, tasks|
              "\n## #{task_type}\n\n" + tasks.map do |task|
                "- #{task.name}"
              end.join("\n")
            end.join("\n") + "\n"
          end.join("\n")
        }
      }
    }

  end
end
