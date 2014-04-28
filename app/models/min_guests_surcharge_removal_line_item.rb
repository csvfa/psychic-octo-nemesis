class MinGuestsSurchargeRemovalLineItem < LineItem
  NOTE = "Auto: Booking now has at least " + PartyLineItem::LOW_GUESTS.to_s + " guests. "
  DESCRIPTION = "Minimum Guests Surcharge removed"
  
  def calculate_and_set_variables
    current_guests = invoice.booking.no_guests(entry_date)
    active_surcharge = invoice.booking.active_min_guests_surcharge
    
    raise "There should not be a Minimum Guests Surcharge Removal because the number of guests (" + current_guests.to_s + ") is less than " + PartyLineItem::LOW_GUESTS.to_s if current_guests < PartyLineItem::LOW_GUESTS
    
    self.no_guests = nil
    self.price_per_guest = nil
    if active_surcharge
      self.amount = -active_surcharge.amount
    else
      self.amount = 0
    end
  end
end