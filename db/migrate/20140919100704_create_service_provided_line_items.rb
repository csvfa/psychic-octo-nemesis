class CreateServiceProvidedLineItems < ActiveRecord::Migration
  def change
    create_table :service_provided_line_items do |t|
      t.date :entry_date
      t.string :description
      t.integer :no_people
      t.decimal :rate_per_person, :precision => 8, :scale => 2
      t.decimal :amount, :precision => 8, :scale => 2
      t.references :invoice

      t.timestamps
    end
  end
end
