class AreWeThereYet
  class Task < ActiveRecord::Base
    include Glimmer
    include Glimmer::DataBinding::ObservableModel
    
    after_initialize :initialize_observers
    after_create :task_list_changed
    after_destroy :task_list_changed
    
    validates :name, presence: true
    validates :project_name, presence: true
    validates :task_type, presence: true
    validates :start_at, presence: true
    validates :duration, presence: true
    validates :priority, presence: true
    
    FILTERS = [:name_filter, :project_name_filter, :task_type_filter, :start_at_filter, :duration_filter, :end_at_filter, :priority_filter]
    TYPE_FILTERS = {
      String => lambda { |value, filter_value| value.to_s.downcase.include?(filter_value.to_s.downcase) },
      Time => lambda { |value, filter_value| filter_value.nil? || value&.strftime('%Y-%m-%d') == filter_value.strftime('%Y-%m-%d') },
    }
    
    class << self
      include Glimmer::DataBinding::ObservableModel      
      attr_accessor *FILTERS
      
      def task_list_changed
        notify_observers(:all)
        notify_observers(:list)
      end
      
      def start_at_filter=(value)
        unless value.nil?
          value = Time.at(value.to_java.time / 1000.0) # TODO add to a Ruby extension or refinement (consider contributing to JRuby)
        end
        @start_at_filter = value
      end

      def end_at_filter=(value)
        unless value.nil?
          value = Time.at(value.to_java.time / 1000.0)
        end
        @end_at_filter = value
      end

      def project_name_filter_options
        [''] + pluck(:project_name).uniq.sort
      end
      
      def task_type_filter_options
        [''] + pluck(:task_type).uniq.sort
      end
      
      def duration_filter_options
        [''] + 
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
        @list = all.to_a if @list.to_a.size != count
        FILTERS.each do |filter|
          @list = @list.select do |task|
            value = task.send(filter.to_s.sub('_filter', ''))
            filter_value = Task.send(filter)
            TYPE_FILTERS[value.class].call(value, filter_value)
          end
        end
        @list
      end
      
      def list=(new_list)
        @list = new_list
      end
      
      def reset_filters
        FILTERS.each do |filter|
          Task.send("#{filter}=", nil)
        end
      end
      
      FILTERS.each do |filter|
        Glimmer::DataBinding::Observer.proc do |new_value|
          Task.task_list_changed
        end.observe(Task, filter)
      end
    end
    
    def initialize_observers
      [:project_name, :task_type, :name, :start_date, :end_date, :duration, :priority].each do |property|
        observe(self, property) do |new_value|
          save!
        end
      end
    end
    
    def task_list_changed
      Task.task_list_changed
    end
    
    def reset
      # intentionally don't reset project name and task type assuming they would used over and over again
      self.id = nil
      self.name = nil
      self.start_at = nil
      self.duration = nil
      self.end_at = nil
      self.priority = nil
      notify_observers(:project_name_options)
      notify_observers(:task_type_options)
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
    
    def priority_sort
      ['High', 'Medium', 'Low'].index(priority)    
    end
    
    def start_at=(value)
      unless value.nil?
        value = Time.at(value.to_java.time / 1000.0)
      end
      super(value)
      notify_observers(:end_at)
    end
    
    def start_at
      return if super.nil?
      Time.at(super.to_time.localtime.to_java.time / 1000.0).localtime
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
