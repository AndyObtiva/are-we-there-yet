class AreWeThereYet
  class Task < ActiveRecord::Base
    include Glimmer::DataBinding::ObservableModel
    after_create :task_list_changed
    after_destroy :task_list_changed
    
    validates :name, presence: true
    validates :project_name, presence: true
    validates :task_type, presence: true
    validates :start_at, presence: true
    validates :duration, presence: true
    validates :priority, presence: true
    
    FILTERS = [:name_filter, :project_name_filter, :task_type_filter, :start_at_filter, :duration_filter, :end_at_filter, :priority_filter]
    
    class << self
      include Glimmer::DataBinding::ObservableModel      
      attr_accessor *FILTERS
      
#       def name_filter=(val)
#         pd "Name Filter Changed: #{val}"
#         @name_filter = val
#         task_list_changed
#       end
#       
#       def priority_filter=(val)
#         pd "Priority Filter Changed: #{val}"
#         @priority_filter = val
#         task_list_changed
#       end
#       
      def task_list_changed
        notify_observers(:all)
        notify_observers(:list)
      end

      def project_name_filter_options
        pluck(:project_name).uniq.sort
      end
      
      def task_type_filter_options
        pluck(:task_type).uniq.sort
      end
      
      def duration_filter_options
        (1..24).map do |h|
          "#{h} hour#{'s' if h > 1}"
        end + 
          (2..62).map do |d|
            "#{d} days"
          end
      end    
      
      def priority_filter_options
        ['', 'High', 'Medium', 'Low']
      end
                  
      def list
        pd 'listing...', header: true
        all.to_a.select do |task|
          task.name.to_s.downcase.include?(name_filter.to_s.downcase)
        end.select do |task|
          task.priority.to_s.downcase.include?(priority_filter.to_s.downcase)
        end
      end
      
      FILTERS.each_with_index do |filter, i|
        if i == 6
          observer = Glimmer::DataBinding::Observer.proc do |new_value|
            pd new_value
            Task.task_list_changed
          end
          pd observer
          observer.observe(Task, filter)
          pd Task, announcer: '[MODEL]'
        end
      end
    end
    
    def task_list_changed
      Task.task_list_changed
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
      Task.project_name_filter_options
    end
    
    def task_type_options
      Task.task_type_filter_options
    end
    
    def duration_options
      Task.duration_filter_options
    end    
    
    def priority_options
      Task.priority_filter_options
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

    def start_date
      start_at&.strftime('%Y-%m-%d')
    end
    
    def end_at=(value)
      return if value.nil?
      value = Time.at(value.to_java.time / 1000.0)
      if start_at.nil? || value < start_at
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
    
    def end_date
      end_at&.strftime('%Y-%m-%d')
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
