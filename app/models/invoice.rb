class Invoice < ActiveRecord::Base
  has_many :service_provided_line_items
  has_many :received_line_items
  belongs_to :booking
  
  validates :deposit_amount, :presence => true
  
  def total   
    service_provided_line_items.sum(:amount)
  end
  
  def vat
    total/5
  end
  
  def net
    total - vat
  end
  
  def total_people
    service_provided_line_items.sum(:no_people)
  end
  
  def amount_outstanding
    total - received_line_items.sum(:amount)
  end
  
  def total_received
    received_line_items.sum(:amount)
  end
  
  def deposit_paid?
    deposit_amount.present? && received_line_items.sum(:amount) >= deposit_amount
  end
  
  def deposit_paid_on
    raise "No deposit payment date because the deposit has not been paid" if !deposit_paid?
    running_total = 0
    deposit_received_date = nil
    received_line_items.each do |line_item|
      running_total += line_item.amount
      deposit_received_date = line_item.received_on if running_total >= deposit_amount
    end
	deposit_received_date
  end
  
  def balance_paid?
    total > 0 && amount_outstanding <= 0
  end
  
  def balance_paid_on
    raise "No balance payment date because the deposit has not been paid" if !balance_paid?
    running_total = 0
    balance_received_date = nil
    received_line_items.each do |line_item|
      running_total += line_item.amount
      balance_received_date = line_item.received_on if running_total >= total
    end
    raise "Could not find a balance payment date for invoice " + self.inspect if balance_received_date.nil?
	balance_received_date
  end
  
  def set_default_dates
    self.deposit_due_date = Date.today + 7.days
    self.balance_due_date = booking.timeslot - 15.days
    self.invoice_date = Date.today
    
    if balance_due_date < deposit_due_date
      # ask greta what to do in this case
    end
  end
  
  def calculate_deposit_amount
    raise "Could not calculate deposit amount because booking has no pricing structure. Booking: " + booking.inspect if booking.pricing_structure.nil?
    amount = ( booking.pricing_structure.rate_per_person * booking.no_guests ) / 2
    
    if amount > booking.pricing_structure.min_cost
      self.deposit_amount = amount
    else
      self.deposit_amount = booking.pricing_structure.min_cost / 2
    end
  end
  
  def create_first_line_item
    s = ServiceProvidedLineItem.new
    s.entry_date = Date.today
    s.description = booking.theme.present? ? booking.theme.name + " party" : "Party (no theme)"
    s.no_people = booking.no_guests
    s.invoice = self
    s.rate_per_person = booking.pricing_structure.rate_per_person
    raise "Could not save first line item: " + s.inspect.to_s + " with these errors: " + s.errors.full_messages.to_s unless s.save
  end  
end