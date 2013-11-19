class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.text :payment_procedure
      t.text :notes
      t.references :city

      t.timestamps
    end
    add_index :venues, :city_id
  end
end
