class AreWeThereYet
  class SimpleTextViewPresenter
    class TaskTypePresenter
      attr_reader :task_presenters
      
      def initialize(task_type, project_presenter)
        @task_type = task_type
        @project_presenter = project_presenter
        @project_presenter.add_task_type_presenter(self)
        @task_presenters = []
      end
      
      def add_task_presenter(task_presenter)
        @task_presenters << task_presenter
      end
      
      def to_s
        "## #{@task_type}"
      end
      
      def line_get_style(event)
      end
    end
  end
end
