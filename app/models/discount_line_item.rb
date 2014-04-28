class DiscountLineItem < LineItem
  def calculate_and_set_variables
    # no_guests and should already be nil, we'll nil it just to be sure
    self.no_guests = nil
    
    # set the amount and ppg to a negative if they aren't. better than throwing an exception because we can reasonabley infer the user's intention if they entered a positive value.
    self.amount = -self.amount.abs
    self.price_per_guest = -self.price_per_guest.abs unless price_per_guest.nil?
    raise "The discount (" + amount.abs.to_s + ") cannot be larger than the value of the booking (" + invoice.booking.amount.to_s + ")" if self.amount.abs > self.invoice.booking.amount
  end
end
