class MakeBookingBelongToCustomer < ActiveRecord::Migration
  def change
  	change_table :bookings do |t|
  		t.references :customer
	end
  end
end
