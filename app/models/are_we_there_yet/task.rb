class AreWeThereYet
  class Task < ActiveRecord::Base
    after_create :notify_create
    
    class << self
      include Glimmer::DataBinding::ObservableModel
      
      def notify_create
        notify_observers('all')  
      end      
    end
    
    validates :name, presence: true
    validates :project_name, presence: true
    validates :task_type, presence: true
    
    def notify_create
      Task.notify_create
    end
    
    def reset
      self.name = nil
      self.project_name = nil
      self.task_type = nil
      self.start_at = nil
      self.duration = nil
      self.priority = nil
    end
    
    def project_name_options
      Task.pluck(:project_name).uniq.sort
    end
    
    def task_type_options
      Task.pluck(:task_type).uniq.sort
    end
    
    def duration_options
      (1..8).map do |h|
        "#{h} hour#{'s' if h > 1}"
      end + 
        (2..30).map do |d|
          "#{d} days"
        end + 
        (2..3).map do |m|
          "#{m} months"
        end
    end    
    
    def priority_options
      %w[High Medium Low]
    end
    
    def duration_in_hours
      value = duration.to_s
      if value.include?('hour')
        value = value.to_i
      elsif value.include?('day')
        value = value.to_i * 24
      elsif value.include?('month')
        value = value.to_i * 24 * 30
      end
      value.to_i
    end
    
    def end_at
      start_at + duration_in_hours * 60 * 60
    end
  end
end
