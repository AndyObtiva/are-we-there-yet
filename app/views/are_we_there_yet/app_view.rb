require 'models/are_we_there_yet/task'

class AreWeThereYet
  class AppView
    include Glimmer::UI::CustomShell
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    option :greeting, default: 'Hello, World!'

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
          display_preferences_dialog
        }
      }
    }

    ## Use after_body block to setup observers for widgets in body
    #
    # after_body {
    # 
    # }

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      shell {
        # Replace example content below with custom shell content
        minimum_size 320, 240
        text "Are We There Yet - App View"
        grid_layout
        table {
          layout_data :fill, :fill, true, true
          table_column {
            text 'Task'
            width 80
          }
          table_column {
            text 'Project'
            width 80
          }
          table_column {
            text 'Type'
            width 80
          }
          table_column {
            text 'Start Date/Time'
            width 80
          }
          table_column {
            text 'Duration (hours)'
            width 80
          }
          table_column {
            text 'Priority'
            width 80
          }
          items bind(Task, :all, on_read: :to_a), column_properties(:name, :project_name, :task_type, :start_at, :duration, :priority)
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
  end
end
