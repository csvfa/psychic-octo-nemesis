class CreateOpeningTimes < ActiveRecord::Migration
  def change
    create_table :opening_times do |t|
      t.integer :day_of_week
      t.time :opening_time
      t.time :closing_time
      t.references :venue

      t.timestamps
    end
    add_index :opening_times, :venue_id
  end
end
