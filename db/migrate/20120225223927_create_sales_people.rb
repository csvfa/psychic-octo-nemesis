class CreateSalesPeople < ActiveRecord::Migration
  def change
    create_table :sales_people do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :events_company

      t.timestamps
    end
    add_index :sales_people, :events_company_id
  end
end
