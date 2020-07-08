# Are We There Yet?

## Background

It is tough to manage multiple projects via standard Office applications, such as Excel and Word. 
It would be overkill to use professional Project Management software for very simple projects.
Are We There Yet? is a simple tool that gives a quick "at a glance" view of multiple small projects and their progress of completion.

## Business Use Cases

- Enter tasks belonging to a project
- View an "at a glance" progress chart of the various task projects

## Business Domain Models

- Task
- Project
- Progress Chart

## Software Use Cases

- Enter Task
- Remove Task
- Edit Task
- List Tasks
- Group Listed Tasks by Project
- Filter Listed Tasks by Project
- List Projects
- Edit Project
- View Progress Chart

## Software Objects

- Task (model)
- Project (model)
- TaskRepository (model)
- ProjectRepository (model)
- ProgressChart (view)
- TaskList (view)
- ProjectList (view)
- Task (view)
- Project (view)

## Non-Functional (Architectural) Requirements

- Single user per app instance
- Local computer use (no network security concerns)
- A few concurrent projects at a time (assume no more than 10 concurrent projects)
- Small projects with a limited number of tasks (assume no more than 100 tasks per project)

## Software Architecture and Design Decisions

- MVP (Model-View-Presenter) pattern by relying on [Glimmer](https://github.com/AndyObtiva/glimmer) GUI and its [bidirectional data-binding support](https://github.com/AndyObtiva/glimmer#data-binding). 
- Progress chart will be implemented as a Gantt Chart via the [Nebula Gantt Chart SWT widget](https://www.eclipse.org/nebula/snippets.php#GanttChart). It will be wrapped as a [Glimmer Custom Widget Gem](https://github.com/AndyObtiva/glimmer#custom-widget-gem) first.
- Data-storage and retrieval performance requirements are very small, so any database system would do.

## Author

[Andy Maleh](https://github.com/AndyObtiva)

## License

[MIT License](LICENSE.txt)

Copyright (c) 2020 Are We There Yet? - Andy Maleh