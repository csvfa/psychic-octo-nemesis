class GuestChangeLineItem < LineItem
  after_save :create_guest_discount, if: :booking_is_eligible_for_guest_discount?
  after_save :create_guest_discount_removal, if: :booking_needs_guest_discount_removal?
  
  after_save :create_eb_discount, if: :booking_is_eligible_for_eb_discount? # this should only add if one was previously removed due to guest change and not expiry
  after_save :create_eb_discount_removal, if: :booking_needs_eb_discount_removal?
  
  after_save :create_min_guests_surcharge, if: :eligible_for_min_guests_surcharge?
  after_save :create_min_guests_surcharge_removal, if: :needs_min_guests_surcharge_removed?
  
  def calculate_and_set_variables
    raise "The number of guests cannot go below one" if self.invoice.booking.no_guests(entry_date) + self.no_guests < 1
    self.price_per_guest = nil
    self.amount = self.no_guests * self.invoice.price_per_guest(entry_date)
    
    # if the deposit's already paid, don't return deposits.
    if no_guests < 0 and invoice.booking.deposit_paid?
      self.amount = amount / 2
      self.note = "Auto: Deposits not returned"
    end
  end
  
  private
  
  def booking_is_eligible_for_guest_discount?
    invoice.booking.no_guests(entry_date) >= GuestDiscountLineItem::GUEST_NUMBER_THRESHOLD and (invoice.booking.no_guests(entry_date) - no_guests) < GuestDiscountLineItem::GUEST_NUMBER_THRESHOLD and !invoice.booking.has_guest_discount?
  end
  
  def booking_needs_guest_discount_removal?
    invoice.booking.no_guests(entry_date) < GuestDiscountLineItem::GUEST_NUMBER_THRESHOLD and (invoice.booking.no_guests(entry_date) - no_guests) >= GuestDiscountLineItem::GUEST_NUMBER_THRESHOLD and !invoice.booking.has_guest_discount_removal?
  end
  
  def create_guest_discount
    gd =                 GuestDiscountLineItem.new
    gd.description =     GuestDiscountLineItem::DESCRIPTION
    gd.entry_date =      entry_date
    gd.note =            GuestDiscountLineItem::NOTE
    gd.price_per_guest = GuestDiscountLineItem::DISCOUNT
    gd.invoice =         invoice.next_open_invoice
    raise "Guest Discount Line Item creation had the following errors: " + gd.errors.to_s unless gd.save
  end
    
  def create_guest_discount_removal
    gdr =                 GuestDiscountRemovalLineItem.new
    gdr.description =     GuestDiscountRemovalLineItem::DESCRIPTION
    gdr.entry_date =      entry_date
    gdr.note =            GuestDiscountRemovalLineItem::NOTE
    gdr.price_per_guest = -GuestDiscountLineItem::DISCOUNT
    gdr.invoice =         invoice.next_open_invoice
    raise "Guest Discount Removal Line Item creation had the following errors: " + gdr.errors.to_s unless gdr.save
  end
  
  def booking_is_eligible_for_eb_discount?
    invoice.booking.active_eb_discount.nil? and invoice.booking.early_bird_discount_removal_line_items.any? and invoice.booking.no_guests(entry_date) >= EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_GUEST_NUMBER_THRESHOLD
  end
  
  def booking_needs_eb_discount_removal?
    !invoice.booking.active_eb_discount.nil? and invoice.booking.no_guests(entry_date) < EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_GUEST_NUMBER_THRESHOLD
  end
  
  def create_eb_discount
    ed =                 EarlyBirdDiscountLineItem.new
    ed.description =     EarlyBirdDiscountLineItem::DESCRIPTION
    ed.entry_date =      entry_date
    ed.expiry_date =     EarlyBirdDiscountLineItem.early_bird_offer_default_expiry_date
    ed.note =            EarlyBirdDiscountLineItem::NOTE
    ed.price_per_guest = EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_PRICE_PER_PERSON
    ed.invoice =         invoice.next_open_invoice
    ed.calculate_and_set_variables
    raise "Early Bird Discount Line Item creation had the following errors: " + ed.errors.to_s unless ed.save
  end
  
  def create_eb_discount_removal
    er =                  EarlyBirdDiscountRemovalLineItem.new
    er.description =      EarlyBirdDiscountRemovalLineItem::DESCRIPTION
    er.entry_date =       entry_date
    er.note =             EarlyBirdDiscountRemovalLineItem::NOTE
    er.price_per_guest =  -EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_PRICE_PER_PERSON
    er.invoice =          invoice.next_open_invoice
    er.calculate_and_set_variables
    raise "Early Bird Discount Removal Line Item creation had the following errors: " + er.errors.to_s unless er.save
  end
  
  def eligible_for_min_guests_surcharge?
    invoice.booking.no_guests(entry_date) < PartyLineItem::LOW_GUESTS and !invoice.booking.active_min_guests_surcharge
  end
  
  def needs_min_guests_surcharge_removed?
    invoice.booking.no_guests(entry_date) >= PartyLineItem::LOW_GUESTS and invoice.booking.active_min_guests_surcharge
  end
  
  def create_min_guests_surcharge
    mg =              MinGuestsSurchargeLineItem.new
    mg.description =  MinGuestsSurchargeLineItem::DESCRIPTION
    mg.entry_date =   entry_date
    mg.note =         MinGuestsSurchargeLineItem::NOTE
    mg.invoice =      invoice.next_open_invoice
    mg.calculate_and_set_variables
    raise "Min Guests Surcharge Line Item creation had the following errors: " + mg.errors.to_s unless mg.save
  end
  
  def create_min_guests_surcharge_removal
    mr =              MinGuestsSurchargeRemovalLineItem.new
    mr.description =  MinGuestsSurchargeRemovalLineItem::DESCRIPTION
    mr.entry_date =   entry_date
    mr.note =         MinGuestsSurchargeRemovalLineItem::NOTE
    mr.invoice =      invoice.next_open_invoice
    mr.calculate_and_set_variables
    raise "Min Guests Surcharge Removal Line Item creation had the following errors: " + mr.errors.to_s unless mr.save
  end
end