class RemoveBookingsIdFromCity < ActiveRecord::Migration
  def change
		remove_column :cities, :bookings_id
	end
end
