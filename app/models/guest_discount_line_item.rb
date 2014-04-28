class GuestDiscountLineItem < DiscountLineItem
  
  GUEST_NUMBER_THRESHOLD =  20
  DISCOUNT =                -5
  DESCRIPTION =             "Guest discount added"
  NOTE =                    "Auto: Booking now has " + GUEST_NUMBER_THRESHOLD.to_s + " or more guests. "
  
  def calculate_and_set_variables
    # ppg has already been set
    self.no_guests = nil
    self.amount = self.price_per_guest * self.invoice.booking.no_guests(entry_date)
  end
end