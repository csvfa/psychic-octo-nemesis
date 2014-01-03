class DiscountLineItem < LineItem
  
  # put this in early bird class
  EARLY_BIRD_OFFER_PRICE_PER_PERSON = -5
  
  def calculate_and_set_variables
    if self.price_per_guest.nil?
      raise "A discount can not have both blank price per guest and amount" if self.amount.nil?
    else
      if self.amount.nil? # it's a price per person discount and we need to calculate the amount
        
        self.amount = self.price_per_guest * self.invoice.no_guests
      else  # the user has supplied both - let's check they haven't made a mistake
        raise "The discount amount doesn't equal the number of guests times the price per guest" if self.amount != self.price_per_guest * self.invoice.no_guests
      end
    end
    
    # set the amount and ppg to a negative if they aren't. better than throwing an exception because we can reasonabley infer the user's intention if they entered a positive value.
    self.amount = -self.amount.abs
    self.price_per_guest = -self.price_per_guest.abs unless self.price_per_guest.nil?
    
    raise "The discount cannot be larger than the value of the booking" if self.amount.abs > self.invoice.booking.amount
    
    # no_guests and should already be nil, we'll nil it just to be sure
    self.no_guests = nil
  end
  
  # put this in early bird class
  def self.early_bird_offer_default_expiry_date
    Date.today.end_of_month
  end
end
