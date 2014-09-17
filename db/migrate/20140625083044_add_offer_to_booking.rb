class AddOfferToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :offer, :string
  end
end
