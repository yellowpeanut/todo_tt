class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.integer :root_id
      t.string :title, null: false
      t.string :description, null: false
      t.string :status
      t.datetime :scheduled_at, null: false
      t.datetime :rescheduled_at
      t.jsonb :recurrence, null: false

      t.timestamps
    end
  end
end
