class CustomToolTipContentReplacer
  include org.eclipse.nebula.widgets.ganttchart.IToolTipContentReplacer
  
  class << self
    def instance
      @instance ||= new
    end
  end
  
  def replaceToolTipPlaceHolder(event, tool_tip_pattern, date_format) 
    date_format = java.text.SimpleDateFormat.new(date_format)
    event_start_date = Time.at(event.start_date.time.to_java.time / 1000.0).localtime
    event_end_date = Time.at(event.end_date.time.to_java.time / 1000.0).localtime
    require 'models/are_we_there_yet/task'
    make_shift_task = AreWeThereYet::Task.new
    make_shift_task.duration_time = event_end_date - event_start_date
    
    tool_tip_pattern.to_s.gsub('#name#', event.name).
                          gsub('#sd#', date_format.format(event.start_date.time)).
                          gsub('#ed#', date_format.format(event.end_date.time)).
                          gsub('#days#', make_shift_task.duration)
  end
end
