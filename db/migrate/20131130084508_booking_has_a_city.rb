class BookingHasACity < ActiveRecord::Migration
  def change
		change_table :bookings do |t|
  		t.references :city
		end
  end
end
