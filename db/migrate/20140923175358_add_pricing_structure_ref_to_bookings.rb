class AddPricingStructureRefToBookings < ActiveRecord::Migration
  def change
		change_table :bookings do |t|
  		  t.references :pricing_structure
		end
  end
end
