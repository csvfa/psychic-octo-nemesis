class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :day_rate
      t.references :city

      t.timestamps
    end
    add_index :coaches, :city_id
  end
end
