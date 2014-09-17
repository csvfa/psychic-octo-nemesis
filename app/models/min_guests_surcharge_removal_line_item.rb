class MinGuestsSurchargeRemovalLineItem < LineItem
  NOTE = "Auto"
  DESCRIPTION = "Previous Minimum Guests Surcharge removed"
  
  def calculate_and_set_variables
    # amount is the amount of the previous surcharge

    self.no_guests = nil
    self.price_per_guest = nil
    self.amount = -invoice.booking.last_min_guests_surcharge_line_item(entry_date).amount
  end
end