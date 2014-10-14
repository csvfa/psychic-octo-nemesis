class DropLineItems < ActiveRecord::Migration
  def up
    drop_table :line_items
  end

  def down
   create_table :line_items do |t|
      t.datetime :entry_date
      t.integer :no_guests
      t.string :type
	  t.decimal :amount, :precision => 8, :scale => 2
      t.text :note
      t.string :action
      t.string :description
      t.date :expiry_date
      t.string :references
      t.references :invoice

      t.timestamps
    end
    add_index :line_items, :invoice_id
    
    add_column :line_items, :price_per_guest, :decimal, :precision => 8, :scale => 2
  end
end