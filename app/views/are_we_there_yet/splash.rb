require 'glimmer-dsl-swt'

class AreWeThereYet
  class Splash
    include Glimmer
    
    display # pre-initialize SWT Display before any threads are later created, so they would auto-reuse it

    class << self
      attr_reader :shell_proxy

      def open
        sync_exec {
          @splash_image = image(File.expand_path(File.join('..', '..', '..', '..', 'are-we-there-yet-logo.png'), __FILE__)).scale_to(128, 128)
          @shell_proxy = shell(:no_trim, :on_top) {
            minimum_size 128, 128
            background rgb(33, 44, 186)
            grid_layout(1, false) {
              margin_width 0
              margin_height 0
            }            
            label {
              background :transparent
              image @splash_image
            }
            cursor display.swt_display.get_system_cursor(swt(:cursor_appstarting))
          }
          @shell_proxy.open
        }
      end

      def close
        sync_exec {
          @shell_proxy&.swt_widget&.close
        }
      end
    end
  end
end
