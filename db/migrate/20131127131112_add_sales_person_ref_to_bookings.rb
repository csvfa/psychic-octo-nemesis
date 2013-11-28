class AddSalesPersonRefToBookings < ActiveRecord::Migration
  def change
		change_table :bookings do |t|
  		t.references :sales_person
		end
  end
end
