class AreWeThereYet
  class Task < ActiveRecord::Base
    after_create :notify_create
    
    class << self
      include Glimmer::DataBinding::ObservableModel
      
      def notify_create
        notify_observers('all')      
      end
      
    end
    
    def notify_create
      Task.notify_create
    end
  end
end
