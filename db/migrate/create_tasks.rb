require 'active_record'

require 'models/are_we_there_yet/task'

class CreateTasks < ActiveRecord::Migration[5.2]
  def up
    create_table :tasks do |t|
      t.string     :project_name
      t.integer    :position, auto_increment: true
      t.string     :name
      t.string     :task_type
      t.timestamp  :start_at
      t.string     :duration
      t.string     :priority
      t.boolean    :finished, default: false
    end
    
    8.times do |n|
      AreWeThereYet::Task.create!(
        project_name: 'MVP',
        position:     n,
        name:         "Task #{n}",
        task_type:    'Development',
        start_at:     (Time.now - 30*24*60*60) + n*4*24*60*60,
        duration:     '4 days',
        priority:     'High',
        finished:     false,
      )
    end    
  end

  def down
    drop_table :tasks
  end
end
