class PartyLineItem < LineItem

  def calculate_and_set_price_per_guest
    case
      when self.no_guests >= 20
        self.price_per_guest = 25
      when self.no_guests >= 10
        self.price_per_guest = 30
    end
  end
  
  def calculate_and_set_amount
    if self.no_guests < 10
      self.amount = 300
    else
      self.amount = self.no_guests * self.price_per_guest
    end
  end
end
