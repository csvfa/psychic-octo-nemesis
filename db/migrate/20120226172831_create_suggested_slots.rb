class CreateSuggestedSlots < ActiveRecord::Migration
  def change
    create_table :suggested_slots do |t|
      t.time :time
      t.references :studio

      t.timestamps
    end
    add_index :suggested_slots, :studio_id
  end
end
