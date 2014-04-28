class Invoice < ActiveRecord::Base
  has_many :ppg_discount_line_items
  has_many :fixed_discount_line_items
  has_many :discount_expiry_line_items
  has_many :guest_change_line_items
  has_many :refund_line_items
  has_many :deposit_payment_line_items
  has_many :balance_payment_line_items
  has_many :line_items
  has_many :early_bird_discount_line_items
  has_many :early_bird_discount_removal_line_items
  has_many :guest_discount_line_items
  has_many :guest_discount_removal_line_items
  has_many :min_guests_surcharge_line_items
  has_many :min_guests_surcharge_removal_line_items
  belongs_to :booking
  
  def amount(date = nil)
    # the total balance for this invoice taking into account line items up to "date"
    
    # this is a decent place to poll for line items that should be created e.g. expired discounts. though it would be good if there was somewhere better.
    check_for_expired_early_bird_discount
    
    # have to set date here coz may have created new line items in prev method
    date = Time.now if !date
    
    t = 0
    line_items.where("entry_date <= ?", date).each do |line_item|
      t += line_item.amount
    end
    t
  end
  
  def vat(date = Time.now)
    amount(date) / 5
  end
  
  def no_guests(date = Time.now)
    g = 0

    line_items.where("entry_date <= ?", date).each do |line_item|
        g += line_item.no_guests unless line_item.no_guests.nil?
    end
    g
  end
  
  def price_per_guest(date = Time.now)
    p = 0
    # add all line items from all invoices. assumes invoices are never added in anything other than linear order.

    booking.invoices.each do |i|
      i.line_items.where("entry_date <= ?", date).each do |line_item|
        p += line_item.price_per_guest unless line_item.price_per_guest.nil?
      end
    end
    p
  end
  
  def check_for_expired_early_bird_discount
    if booking.active_eb_discount and booking.active_eb_discount.expired?
      exp =                 DiscountExpiryLineItem.new
      exp.description =     DiscountExpiryLineItem::EB_DISCOUNT_EXPIRY_DESCRIPTION
      exp.entry_date =      Time.now.round # don't do Time.now because Ruby time resolution may not match database, just do seconds. This was a nasty bug to diagnose!
      exp.note =            DiscountExpiryLineItem::EARLY_BIRD_EXPIRY_NOTE
      exp.price_per_guest = -booking.active_eb_discount.price_per_guest
      exp.invoice =         next_open_invoice
      raise "Expired Discount Line Item creation had the following errors: " + exp.errors.to_s unless exp.save
    end
  end
  
  def next_open_invoice
    # used when auto-creating line items, to ensure the line item doesn't go in a closed invoice. if no open invoices, creates a new one 
    found_self = false
    next_open = nil
    
    booking.invoices.order(:invoice_date).each do |i|
      found_self = true if i == self # effectively ignores invoices previous to self
      next_open = i if found_self and i.open?
    end
    
    if next_open.nil? # no open invoices so create a new one
      next_open =               Invoice.new
      next_open.invoice_date =  Date.today
      next_open.booking =       booking
      next_open.set_default_dates
      raise "Invoice creation had the following errors: " + next_open.errors.to_s unless next_open.save
    end
    
    raise "'next_open' variable should not be nil" if next_open.nil?
    next_open
  end
  
  def set_default_dates
    self.deposit_due_date = Date.today + 7.days
    self.balance_due_date = booking.timeslot - 15.days
    
    if balance_due_date < deposit_due_date
      # ask greta what to do in this case
    end
  end
    
  def open?
    deposit_payment_line_items.empty? and balance_payment_line_items.empty?
  end
end
