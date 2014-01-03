class GuestChangeLineItem < LineItem
  def calculate_and_set_variables
    new_no_guests = self.invoice.booking.no_guests + self.no_guests
    raise "The number of guests cannot go below one" if new_no_guests < 1
    self.price_per_guest = nil
    self.amount = new_no_guests * self.invoice.price_per_guest
  end
end