class AddStudioRefToBookings < ActiveRecord::Migration
  def change
    change_table :bookings do |t|
  		t.references :studio
		t.remove_references :venue
	end
  end
end
