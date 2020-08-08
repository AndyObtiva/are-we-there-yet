class AreWeThereYet
  class SimpleTextViewPresenter
    class BlankLinePresenter
      def initialize
      end      
      
      def to_s
        ""
      end
      
      def style_range
        StyleRange.new.tap { |style|
          style.start = 0
          style.length = 0
          style.fontStyle = swt(:normal)
        }      
      end
    end
  end
end
