require 'active_record'

require 'models/are_we_there_yet/task'

class CreateTasks < ActiveRecord::Migration[5.2]
  def up
    create_table :tasks do |t|
      t.string     :project_name
      t.string     :name
      t.string     :task_type
      t.timestamp  :start_at
      t.integer    :duration
      t.string     :priority
      t.integer    :position
    end
    
    8.times do |n|
      AreWeThereYet::Task.create!(
        project_name: 'MVP',
        name:         "Create task #{n}",
        task_type:    'Development',
        start_at:     "2020-07-0#{n+1} 12:47:38",
        duration:     n+1,
        priority:     'High',
        position:     n
      )
    end    
  end

  def down
    drop_table :tasks
  end
end
