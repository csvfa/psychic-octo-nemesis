class EarlyBirdDiscountLineItem < PPGDiscountLineItem
  after_save  :check_for_expired_early_bird_discount     # in case it has already expired
  
  EARLY_BIRD_OFFER_PRICE_PER_PERSON = -5
  EARLY_BIRD_OFFER_GUEST_NUMBER_THRESHOLD = 12
  NOTE = "Auto"
  DESCRIPTION = "Early Bird Offer"
  
  def default_expiry_date
    # Early bird expires at end of month of original enquiry. Use the booking created_at as a proxy
    invoice.booking.created_at.end_of_month
  end
  
  def check_for_expired_early_bird_discount
    invoice.check_for_expired_early_bird_discount
  end
  
  def expired?
    expiry_date < Date.today
  end
  
  # this class doesn't seem to call the inherited method of LineItem (maybe because it's too many levels away?), somy hacky solution is to manually override the model_name to be LineItem's. Any subclasses of this are on their own, unfortunately. This means form_for and other methods work. for more background, see http://stackoverflow.com/questions/4507149/best-practices-to-handle-routes-for-sti-subclasses-in-rails?lq=1
  def self.model_name
    LineItem.model_name
  end
end