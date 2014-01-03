class Invoice < ActiveRecord::Base
  has_many :discount_line_items
  has_many :guest_change_line_items
  has_many :refund_line_items
  has_many :deposit_payment_line_items
  has_many :balance_payment_line_items
  has_many :line_items
  belongs_to :booking
  
  def amount
    t = 0
    self.line_items.each do |line_item|
      t += line_item.amount
    end
    t
  end
  
  def vat
    amount / 5
  end
  
  def no_guests
    g = 0
    self.line_items.each do |line_item|
      g += line_item.no_guests unless line_item.no_guests.nil?
    end
    g
  end
  
  def price_per_guest
    p = 0
    self.line_items.each do |line_item|
      p += line_item.price_per_guest unless line_item.price_per_guest.nil?
    end
    p
  end
  
  # redo this when eb_discount is implemented
  def early_bird_offer
  # assumes there's only one (and there should be only one)
    self.line_items.where("expiry_date NOT NULL").first
  end
end
