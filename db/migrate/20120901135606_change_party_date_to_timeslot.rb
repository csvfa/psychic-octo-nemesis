class ChangePartyDateToTimeslot < ActiveRecord::Migration
  def up
  	change_column :bookings, :party_date, :datetime
  	rename_column :bookings, :party_date, :timeslot
  end

  def down
  	change_column :bookings, :party_date, :date
  	rename_column :bookings, :timeslot, :party_date
  end
end
