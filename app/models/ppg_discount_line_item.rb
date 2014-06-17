class PPGDiscountLineItem < DiscountLineItem
  def calculate_and_set_variables
    raise "A price per guest discount must have a price per guest change" if price_per_guest.nil?
    self.amount = price_per_guest * invoice.booking.no_guests(entry_date)
    super
  end
  
  # this class doesn't seem to call the inherited method of LineItem (maybe because it's too many levels away?), somy hacky solution is to manually override the model_name to be LineItem's. Any subclasses of this are on their own, unfortunately. This means form_for and other methods work. for more background, see http://stackoverflow.com/questions/4507149/best-practices-to-handle-routes-for-sti-subclasses-in-rails?lq=1
  def self.model_name
    LineItem.model_name
  end
end
