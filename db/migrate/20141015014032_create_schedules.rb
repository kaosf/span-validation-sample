class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :title
      t.datetime :start_at
      t.datetime :finish_at

      t.timestamps
    end
  end
end
