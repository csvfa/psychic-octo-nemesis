class AddRatePerGuestAndOfferDateToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :rate_per_guest, :decimal, :precision => 8, :scale => 2

    add_column :bookings, :offer_expires_on, :date

  end
end
