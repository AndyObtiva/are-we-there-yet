require 'models/are_we_there_yet/task'
require 'models/are_we_there_yet/simple_text_view_presenter/blank_line_presenter'
require 'models/are_we_there_yet/simple_text_view_presenter/project_presenter'
require 'models/are_we_there_yet/simple_text_view_presenter/task_presenter'
require 'models/are_we_there_yet/simple_text_view_presenter/task_type_presenter'

class AreWeThereYet
  class SimpleTextViewPresenter
    class << self
      def text
        presenter_list.map(&:to_s).join("\n")
      end
      
      def presenter_list
        grouped_task_list.map do |project_name, project_task_types|          
          project_presenter = ProjectPresenter.new(project_name)
          [project_presenter, BlankLinePresenter.new] + project_task_types.map do |task_type, tasks|
            task_type_presenter = TaskTypePresenter.new(task_type, project_presenter)
            [task_type_presenter, BlankLinePresenter.new] + tasks.map do |task|
              TaskPresenter.new(task, task_type_presenter)
            end + [BlankLinePresenter.new]
          end.flatten
        end.flatten
      end
      
      def grouped_task_list
        Task.list.to_a.group_by(&:project_name).reduce({}) do |hash, project|
          project_name, project_tasks = project
          hash.merge(project_name => project_tasks.group_by(&:task_type))
        end    
      end
      
      def list=(value)
        # TODO
      end
    end
  end
end
