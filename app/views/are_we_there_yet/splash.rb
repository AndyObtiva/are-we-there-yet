require 'glimmer-dsl-swt'

class AreWeThereYet
  class Splash
    include Glimmer
    
    display # pre-initialize SWT Display before any threads are later created, so they would auto-reuse it

    class << self
      attr_reader :shell_proxy

      def open
        sync_exec {
          @splash_image = image(File.expand_path(File.join('..', '..', '..', '..', 'are-we-there-yet-splash.gif'), __FILE__)).scale_to(118, 118)
          @shell_proxy = shell(:no_trim, :on_top) {
            minimum_size 128, 128
#             background rgb(33, 44, 186)
            background :white
            grid_layout(1, false) {
              margin_width 0
              margin_height 0
            }
            composite {
              layout_data(:center, :center, true, true) {              
                width_hint 118
                height_hint 118
              }
              background_image @splash_image              
            }
            cursor display.swt_display.get_system_cursor(swt(:cursor_appstarting))
          }
          @shell_proxy.open
        }
      end

      def close
        async_exec {
          @shell_proxy&.swt_widget&.close
        }
      end
    end
  end
end
