class RemoveBookingFromCityAndAddCityToBooking < ActiveRecord::Migration
  def up
		remove_column :cities, :booking_id
		add_column :bookings, :city_id, :integer
  end

  def down
		add_column :cities, :booking_id, :integer
		remove_column :bookings, :city_id
  end
end
