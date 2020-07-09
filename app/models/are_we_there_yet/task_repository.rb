require 'models/are_we_there_yet/task'

class AreWeThereYet
  class TaskRepository
    class << self
      def instance
        @instance ||= new
      end
    end
    
    def all
      Task.all.to_a
    end
  end
end
