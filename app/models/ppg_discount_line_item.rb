class PPGDiscountLineItem < DiscountLineItem
  def calculate_and_set_variables
    raise "A price per guest discount must have a price per guest change" if price_per_guest.nil?
    self.amount = price_per_guest * invoice.booking.no_guests(entry_date)
    super
  end
end
