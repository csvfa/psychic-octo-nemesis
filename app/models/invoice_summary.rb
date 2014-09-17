class InvoiceSummary
  attr_reader :id, :issue_date, :summary_line_items, :subtotal_summary_line_item
  
  def initialize(invoice)
    @invoice = invoice
    @id = invoice.id
    @issue_date = invoice.invoice_date
    @summary_line_items = construct_summary_line_items
    @subtotal_summary_line_item = SubtotalSummaryLineItem.new(invoice)
  end
  
  private
  def construct_summary_line_items
    summary_line_items = []

    @invoice.line_items.each do |l|
      if l.is_a? PartyLineItem
        summary_line_items << PartySummaryLineItem.new(@invoice)
      end
      if l.is_a? DepositPaymentLineItem
        summary_line_items << DepositPaymentSummaryLineItem.new(l)
      end
      if l.is_a? BalancePaymentLineItem and not l.is_a? DepositPaymentLineItem
        summary_line_items << BalancePaymentSummaryLineItem.new(l)
      end
      if l.is_a? FixedDiscountLineItem
        summary_line_items << DiscountSummaryLineItem.new(l)
      end
      if l.is_a? RefundLineItem
        summary_line_items << RefundSummaryLineItem.new(l)
      end
      if l.is_a?(GuestChangeLineItem) && @invoice.booking.deposit_paid? && l.entry_date > @invoice.booking.last_deposit_payment.entry_date
        summary_line_items << GuestChangeSummaryLineItem.new(l)
      end
    end
    
    summary_line_items
  end
end