class Invoice < ActiveRecord::Base
  has_many :service_provided_line_items
  has_many :received_line_items
  belongs_to :booking
  
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
  
  def deposit
    total/2 # this will be dynamic so when new services are added the deposit will update
  end
  
  def final_balance
    total - deposit
  end
  
  def amount_outstanding
    total - received_line_items.sum(:amount)
  end
  
  def deposit_paid?
    received_line_items.sum(:amount) >= deposit
  end
  
  def set_default_dates
    self.deposit_due_date = Date.today + 7.days
    self.balance_due_date = booking.timeslot - 15.days
    
    if balance_due_date < deposit_due_date
      # ask greta what to do in this case
    end
  end
end