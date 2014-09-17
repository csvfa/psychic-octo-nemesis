class RefundSummaryLineItem < BasicSummaryLineItem  
  def initialize(refund_line_item)
    description = "Refund"
    amount_owed = refund_line_item.amount
    amount_received = 0
    super(description, amount_owed, amount_received)
  end
end