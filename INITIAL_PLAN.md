# <img src="https://raw.githubusercontent.com/AndyObtiva/are-we-there-yet/master/are-we-there-yet-logo.svg" height=40 /> Are We There Yet? - Initial Plan

“Plans are nothing; planning is everything” - Former US President Dwight D Eisenhower

## Background

For very simple projects, enterprise project management software is too large and complicated to setup and not conventient enough to use.

Are We There Yet? aims to be an alternative that provides a quick "at a glance" view of multiple small projects and their progress of completion.

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
- Sort Tasks
- Filter Tasks
- Group Listed Tasks by Project
- Reorder Tasks per Project
- Mark Task as Started
- Mark Task as Finished
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
- Data-storage and retrieval performance requirements are very small, so any database system would do. Decided to go with [SQLite](https://www.sqlite.org/famous.html) (included in MacOS) and the [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) ORM.

## Author

[Andy Maleh](https://github.com/AndyObtiva)

## License

[MIT License](LICENSE.txt)

Copyright (c) 2020 - Are We There Yet? by [Andy Maleh](https://github.com/AndyObtiva)
