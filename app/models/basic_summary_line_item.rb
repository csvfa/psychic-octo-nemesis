class BasicSummaryLineItem
  attr_reader :description, :amount_owed, :amount_received
  
  def initialize(description, amount_owed, amount_received)
    @description = description
    @amount_owed = amount_owed
    @amount_received = amount_received
  end
end