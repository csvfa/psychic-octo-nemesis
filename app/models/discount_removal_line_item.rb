class DiscountRemovalLineItem < LineItem
  validates_presence_of :price_per_guest
  
  def calculate_and_set_variables
    self.no_guests = nil
    # ppg should be set by whatever creates this object, as it will have visibility of the original discount line item. I don't.
    self.amount = self.price_per_guest * self.invoice.booking.no_guests(entry_date)
    raise "Discount removal amount must be a positive value" if self.amount < 0
  end
end