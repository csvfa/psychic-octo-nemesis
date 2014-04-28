class FixedDiscountLineItem < DiscountLineItem
  def calculate_and_set_variables
    raise "A fixed discount must have an amount" if amount.nil?
    super
  end
end
