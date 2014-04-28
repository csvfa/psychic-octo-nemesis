class MinGuestsSurchargeLineItem < LineItem
  NOTE = "Auto: Fewer than " + PartyLineItem::LOW_GUESTS.to_s + " guests. "
  DESCRIPTION = "Minimum Guests Surcharge"
  
  def calculate_and_set_variables
    current_guests = invoice.booking.no_guests(entry_date)
    raise "There should not be a Minimum Guests Surcharge because the number of guests (" + current_guests.to_s + ") is more than " + PartyLineItem::LOW_GUESTS.to_s if current_guests >= PartyLineItem::LOW_GUESTS
    self.no_guests = nil
    self.price_per_guest = nil
    self.amount = PartyLineItem::HIGH_PPG * (PartyLineItem::LOW_GUESTS - current_guests)
  end
end
