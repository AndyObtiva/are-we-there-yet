class AreWeThereYet
  class SimpleTextViewPresenter
    class ProjectPresenter
      include Glimmer
      attr_reader :task_type_presenters
      
      def initialize(project_name)
        @project_name = project_name
        @task_type_presenters = []
      end
      
      def add_task_type_presenter(task_type_presenter)
        @task_type_presenters << task_type_presenter
      end
      
      def to_s
        "# #{@project_name}"
      end
      
#       def line_get_style(event)
#         styles(event)      
#       end
#       
#       def styles(event)
#         pd 'header', header: true
#         text_style = TextStyle.new(font(height: 24).swt_font, color(:red).swt_color, color(:green).swt_color)
#         style = StyleRange.new(text_style)
#         pd style.start = event.lineOffset
#         pd style.length = to_s.length
#         style.fontStyle = swt(:bold)
#         event.ranges = [style.start, style.length]
#         event.styles = [style]
#       end

      
      def style_range
        StyleRange.new.tap { |style|
          style.start = 0
          style.length = to_s.size
          style.fontStyle = swt(:bold)
        }      
      end
    end
  end
end
