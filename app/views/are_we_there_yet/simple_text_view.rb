require 'models/are_we_there_yet/task'
require 'models/are_we_there_yet/simple_text_view_presenter'

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
    before_body {
      @presenter = SimpleTextViewPresenter
    }

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
        text bind(@presenter, :text)
        left_margin 5
        right_margin 5
        line_index = 0
        style_ranges [
          StyleRange.new.tap { |style|
            style.start = 0
            style.length = 50
            style.fontStyle = swt(:bold)
          }
        ].to_java(StyleRange)
#         on_line_get_style { |event|
#           @presenter.presenter_list[line_index]&.line_get_style(event)
#           line_index += 1
#           event.styles.to_a.each do |style|
#             pd event.widget.style_range = style
#           end
#           pd event.widget.style_ranges.size
#         }
      }
    }

  end
end
