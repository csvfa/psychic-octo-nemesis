class DropBookingCityReferenceAndAddCityBookingReference < ActiveRecord::Migration
  def up
		change_table :cities do |t|
			t.references :booking
		end
		
		remove_column :bookings, :city_id
  end

  def down
		change_table :bookings do |t|
  		t.references :city
		end
		
		remove_column :cities, :booking_id
  end
end
