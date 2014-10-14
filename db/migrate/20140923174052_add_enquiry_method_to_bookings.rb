class AddEnquiryMethodToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :enquiry_method, :text

  end
end
