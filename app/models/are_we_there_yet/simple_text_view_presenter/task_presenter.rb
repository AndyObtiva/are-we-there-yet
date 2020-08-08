class AreWeThereYet
  class SimpleTextViewPresenter
    class TaskPresenter
      def initialize(task, task_type_presenter)
        @task = task
        @task_type_presenter = task_type_presenter
        @task_type_presenter.add_task_presenter(self)
      end      
      
      def to_s
#         suffix = "\n" if @task_type_presenter.task_presenters.last == self
        "- #{@task.name}" # #{suffix}"
      end
      
      def style_range
        StyleRange.new.tap { |style|
          style.start = 0
          style.length = to_s.size
          style.fontStyle = swt(:normal)
        }      
      end
    end
  end
end
