class DiscountLineItem < LineItem
  
  EARLY_BIRD_OFFER_PRICE_PER_PERSON = -5
  
  def calculate_and_set_amount
    unless self.price_per_guest.nil?
      self.amount = self.price_per_guest * self.no_guests
    end
  end
  
  def self.early_bird_offer_default_expiry_date
    Date.today.end_of_month
  end
end
