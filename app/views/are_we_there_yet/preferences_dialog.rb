class AreWeThereYet
  class PreferencesDialog
    include Glimmer::UI::CustomShell
    
    ## Add options like the following to configure CustomShell by outside consumers
    #
    # options :title, :background_color
    # option :width, default: 320
    # option :height, default: 240
    option :parent_shell_proxy

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

    ## Add widget content inside custom shell body
    ## Top-most widget must be a shell or another custom shell
    #
    body {
      dialog(parent_shell_proxy.swt_widget) {
        text 'Preferences'
        # TODO update this to expose GanttChartSettings class
      }
    }
  end
end
