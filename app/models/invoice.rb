class Invoice < ActiveRecord::Base
  has_many :discount_line_items
  has_many :guest_change_line_items
  has_many :refund_line_items
  has_many :deposit_payment_line_items
  has_many :balance_payment_line_items
  has_many :line_items
  belongs_to :booking
  
  def total
    t = 0
    self.line_items.each do |line_item|
      t += line_item.amount
    end
    
    t
  end
  
  def vat
    total / 5
  end
  
  def early_bird_offer
  # assumes there's only one (and there should be only one)
    self.line_items.where("expiry_date NOT NULL").first
  end
end
