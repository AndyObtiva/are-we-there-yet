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
      
      def line_get_style(event)
      end
    end
  end
end
