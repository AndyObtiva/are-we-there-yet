class AreWeThereYet
  class SimpleTextViewPresenter
    class ProjectPresenter
      attr_reader :task_type_presenters
      
      def initialize(project_name)
        @project_name = project_name
        @task_type_presenters = []
      end
      
      def add_task_type_presenter(task_type_presenter)
        @task_type_presenters << task_type_presenter
      end
      
      def to_s
        "# #{@project_name}\n"
      end
    end
  end
end
