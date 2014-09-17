class GuestChangeSummaryLineItem < GuestSummaryLineItem
  attr_reader :guest_change, :price_per_guest
  
  def initialize(guest_change_line_item)
    if guest_change_line_item.no_guests > 0
      description = "Added on"
    else
      description = "Dropped out"
    end
    
    guest_change = guest_change_line_item.no_guests
    price_per_guest = guest_change_line_item.invoice.price_per_guest(guest_change_line_item.entry_date)
    amount_owed = guest_change_line_item.amount

    if guest_change_line_item.associated_guest_change_discount.present?
      amount_owed += guest_change_line_item.associated_guest_change_discount.amount
    elsif guest_change_line_item.associated_guest_change_discount_removal.present?
      amount_owed += guest_change_line_item.associated_guest_change_discount_removal.amount
    end
    
    amount_received = 0
    
    super(description, guest_change, price_per_guest, amount_owed, amount_received)
  end
end