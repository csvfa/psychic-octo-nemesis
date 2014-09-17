class PartySummaryLineItem < GuestSummaryLineItem  
  def initialize(invoice)
    invoice.booking.theme.present? ? description = invoice.booking.theme.name : description = "Party (no theme)"
    guest_change = invoice.party_line_item.no_guests
    price_per_guest = invoice.party_line_item.price_per_guest
    amount_owed = invoice.party_line_item.amount
        
    #before deposit payment, roll everything up. after deposit payment, list line items individually.
    # here, roll up the 'pres'; in invoice summary, only add post deposit line items
    
    invoice.booking.pre_deposit_payment_line_items.each do |p|
      unless p.is_a? PartyLineItem
        guest_change += p.no_guests.to_i
        price_per_guest += p.price_per_guest.to_f
        amount_owed += p.amount.to_f
      end
    end
    
    amount_received = 0
    super(description, guest_change, price_per_guest, amount_owed, amount_received)
  end
end