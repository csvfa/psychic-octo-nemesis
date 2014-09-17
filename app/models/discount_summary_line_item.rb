class DiscountSummaryLineItem < BasicSummaryLineItem  
  def initialize(fixed_discount_line_item)
    description = "Discount"
    amount_owed = fixed_discount_line_item.amount
    amount_received = 0
    super(description, amount_owed, amount_received)
  end
end