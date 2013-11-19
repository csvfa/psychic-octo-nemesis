class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.integer :capacity
      t.integer :price
      t.time :available_from
      t.time :available_to
      t.text :notes
      t.references :venue

      t.timestamps
    end
    add_index :studios, :venue_id
  end
end
