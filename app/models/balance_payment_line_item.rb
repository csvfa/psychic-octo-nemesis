class BalancePaymentLineItem < LineItem
  def calculate_and_set_variables
    # set the amount to a negative if it isn't. better than throwing an exception because we can reasonable infer the user's intention if they entered a positive amount.
    self.amount = -self.amount.abs
    
    # no_guests and ppg should already be nil, we'll nil them just to be sure
    self.no_guests = nil
    self.price_per_guest = nil
  end
end
