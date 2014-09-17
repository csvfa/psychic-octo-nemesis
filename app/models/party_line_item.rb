class PartyLineItem < LineItem
  
  after_save :create_min_guests_surcharge, if: :eligible_for_min_guests_surcharge?
  
  LOW_PPG =     25
  HIGH_PPG =    30
  LOW_GUESTS =  10
  HIGH_GUESTS = 20
  MIN_AMOUNT =  300
  
  def calculate_and_set_variables
    #case
    #  when self.no_guests >= HIGH_GUESTS
    #    self.price_per_guest = LOW_PPG
    #  when self.no_guests >= LOW_GUESTS
    #    self.price_per_guest = HIGH_PPG
    #end
  
    #if self.no_guests < LOW_GUESTS
    #  self.price_per_guest = HIGH_PPG
    #  self.amount = MIN_AMOUNT
    #else
    #  self.amount = self.no_guests * self.price_per_guest
    #end
    if no_guests > HIGH_GUESTS
      self.price_per_guest = LOW_PPG
    else
      self.price_per_guest = HIGH_PPG
    end
    
    self.amount = no_guests * price_per_guest
  end
  
  private
  def eligible_for_min_guests_surcharge?
    no_guests < LOW_GUESTS && invoice.min_guests_surcharge_line_items.empty?
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
end
