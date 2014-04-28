class CreateAvailabilitySlots < ActiveRecord::Migration
  def change
    create_table :availability_slots do |t|
      t.time :available_from
      t.time :available_to
      t.references :studio

      t.timestamps
    end
  end
end
