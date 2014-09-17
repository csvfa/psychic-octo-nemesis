class GuestSummaryLineItem < BasicSummaryLineItem
  attr_reader :guest_change, :price_per_guest
  
  def initialize(description, guest_change, price_per_guest, amount_owed, amount_received)
    super(description, amount_owed, amount_received)
    @guest_change = guest_change
    @price_per_guest = price_per_guest
  end
end