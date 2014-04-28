class PartyLineItem < LineItem
  
  LOW_PPG =     25
  HIGH_PPG =    30
  LOW_GUESTS =  10
  HIGH_GUESTS = 20
  MIN_AMOUNT =  300
  
  def calculate_and_set_variables
    case
      when self.no_guests >= HIGH_GUESTS
        self.price_per_guest = LOW_PPG
      when self.no_guests >= LOW_GUESTS
        self.price_per_guest = HIGH_PPG
    end
  
    if self.no_guests < LOW_GUESTS
      self.amount = MIN_AMOUNT
    else
      self.amount = self.no_guests * self.price_per_guest
    end
  end
end
