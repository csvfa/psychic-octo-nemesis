class CreatePricingStructures < ActiveRecord::Migration
  def change
    create_table :pricing_structures do |t|
      t.text :name
      t.decimal :rate_per_person, :precision => 8, :scale => 2
      t.integer :min_people
      t.decimal :min_cost, :precision => 8, :scale => 2
      t.date :expiry_date
      t.text :terms
      t.text :notes
      t.text :initial_response
      t.text :booking_response

      t.timestamps
    end
  end
end
