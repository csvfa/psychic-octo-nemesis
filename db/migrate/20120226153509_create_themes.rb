class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.text :gifts
      t.text :kit

      t.timestamps
    end
  end
end
