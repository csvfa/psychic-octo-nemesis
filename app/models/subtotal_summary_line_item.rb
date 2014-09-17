class SubtotalSummaryLineItem < BasicSummaryLineItem
  def initialize(invoice)
    super("Subtotal", invoice.total_amount_owed, invoice.total_amount_received.abs)
  end
end