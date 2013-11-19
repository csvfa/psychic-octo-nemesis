class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer :number
      t.datetime :changed_at
      t.references :booking

      t.timestamps
    end
    add_index :guests, :booking_id
  end
end
