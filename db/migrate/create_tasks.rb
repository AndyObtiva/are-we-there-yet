require 'active_record'

require 'models/are_we_there_yet/task'

class CreateTasks < ActiveRecord::Migration[5.2]
  def up
    create_table :tasks do |t|
      t.string     :project_name
      t.integer    :position, auto_increment: true
      t.string     :name
      t.string     :task_type
      t.date       :start_at
      t.string     :duration
      t.string     :priority
      t.boolean    :finished, default: false
    end
    
    9.times do |n|
      AreWeThereYet::Task.create!(
        project_name: ['Interior', 'Exterior', 'Roof'][n%3],
        position:     n,
        name:         ["Purchase ##{n+1}", "Custom Design ##{n+1}", "Installation ##{n+1}"][n/3%3],
        task_type:    ['Procurement', 'Design', 'Decoration'][n%3],
        start_at:     (Time.now - 30*24*60*60) + n*4*24*60*60,
        duration:     ['4 days', '2 days', '7 days'][n/3%3],
        priority:     ['High', 'Medium', 'Low'][n%3],
        finished:     false,
      )
    end    
  end

  def down
    drop_table :tasks
  end
end
