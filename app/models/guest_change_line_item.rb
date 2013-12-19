class GuestChangeLineItem < LineItem
  def calculate_and_set_price_per_guest
    case
      when self.no_guests >= 20
        self.price_per_guest = 25
      when self.no_guests >= 10
        self.price_per_guest = 30
    end
  end
  
  def calculate_and_set_amount
    # amount = ((new no guests - old no guests) * price per guest)
    self.amount = (self.no_guests - LineItem.latest_with_num_guests(self).no_guests) * self.price_per_guest
  end
end
