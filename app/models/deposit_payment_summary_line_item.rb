class DepositPaymentSummaryLineItem < BasicSummaryLineItem  
  def initialize(deposit_payment_line_item)
    description = "Deposit paid " + deposit_payment_line_item.entry_date.to_s(:date_only)
    amount_owed = 0
    amount_received = deposit_payment_line_item.amount.abs
    super(description, amount_owed, amount_received)
  end
end