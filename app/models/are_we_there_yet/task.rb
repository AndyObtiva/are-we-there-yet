class AreWeThereYet
  class Task < ActiveRecord::Base
    include Glimmer::DataBinding::ObservableModel
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
      self.end_at = nil
      self.priority = nil
    end
    
    def project_name_options
      Task.pluck(:project_name).uniq.sort
    end
    
    def task_type_options
      Task.pluck(:task_type).uniq.sort
    end
    
    def duration_options
      (1..24).map do |h|
        "#{h} hour#{'s' if h > 1}"
      end + 
        (2..62).map do |d|
          "#{d} days"
        end
    end    
    
    def priority_options
      %w[High Medium Low]
    end
    
    # TODO override start_at= and duration= to make them auto-update 2 other fields in (start_at, duration, end_at) trio
    
    def start_at=(value)
      unless value.nil?
        value = Time.at(value.to_java.time / 1000.0)
      end
      super(value)
      notify_observers(:end_at)
    end
    
    def start_at
      return if super.nil?
      Time.at(super.to_java.time / 1000.0)
    end

    def end_at=(value)
      return if value.nil? || start_at.nil?
      value = Time.at(value.to_java.time / 1000.0)
      if value < start_at
        calculated_start_at = value - duration_time
        self.start_at = calculated_start_at
      else
        calculated_duration_time = value - start_at
        self.duration_time = calculated_duration_time
      end
    end
    
    def end_at
      return if start_at.nil?
      start_at + duration_time
    end
    
    def duration=(value)
      super(value)
      notify_observers(:end_at)
    end
    
    def duration_time
      duration_in_hours * 60 * 60
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
    
    def duration_time=(value)
      duration_in_hours = (value / (60.0 * 60)).to_i
      if duration_in_hours <= 24
        self.duration = "#{duration_in_hours} hour#{'s' if duration_in_hours > 1}"
      elsif duration_in_hours <= 62*24
        self.duration = "#{(duration_in_hours/24.0).to_i} days"
      end
    end
  end
end
