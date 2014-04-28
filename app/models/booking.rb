class Booking < ActiveRecord::Base
  has_one :guest, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  
  has_many :ppg_discount_line_items, :through => :invoices
  has_many :fixed_discount_line_items, :through => :invoices
  has_many :discount_expiry_line_items, :through => :invoices
  has_many :guest_change_line_items, :through => :invoices
  has_many :refund_line_items, :through => :invoices
  has_many :deposit_payment_line_items, :through => :invoices
  has_many :balance_payment_line_items, :through => :invoices
  has_many :line_items, :through => :invoices
  has_many :early_bird_discount_line_items, :through => :invoices
  has_many :early_bird_discount_removal_line_items, :through => :invoices
  has_many :guest_discount_line_items, :through => :invoices
  has_many :guest_discount_removal_line_items, :through => :invoices
  has_many :min_guests_surcharge_line_items, :through => :invoices
  has_many :min_guests_surcharge_removal_line_items, :through => :invoices
  
	belongs_to :theme
	belongs_to :coach
	belongs_to :studio
	belongs_to :customer
	belongs_to :sales_person
	belongs_to :city
	
	accepts_nested_attributes_for :guest
	accepts_nested_attributes_for :customer

	def new
		s = events.build :code => 'Query received'
		s.save
		g = guests.build :number => 0
		g.save
	end
	
	def to_s
		to_string
	end
	
	def to_string
		name
	end
  
	def name
		if studio.nil?
			customer.to_s
		else
			customer.to_s + " at " + studio.venue.to_s
		end
	end
	
	def current_event
		if events.empty?
			s = events.build :code => 'Query received'
			s.save
			s
		else
			events.last
		end
	end
	
	def self.orderedByTimeslotOn(regions, date)
		# returns all bookings in a given array of regions, for a given day, in order of timeslot
        # need to then order by city, and then by time
        Booking.where(timeslot: date.midnight..(date.midnight + 1.day)).joins(:city).where("cities.region IN (?)", regions).order('latitude DESC', 'timeslot')
	end
	
	def self.in_timeslot(slot, studio, city = nil)
		#returns all bookings on the given date, between the given time and 14 minutes after it, in the given studio
		if studio.nil?
			Booking.where(timeslot: slot..(slot + 14.minutes)).where(studio_id: nil).order('timeslot')
		else
			Booking.where(timeslot: slot..(slot + 14.minutes)).where(studio_id: studio.id).order('timeslot')
		end
	end
	
	def self.datesOfCurrentBookings(regions)
		# returns an array of dates of bookings that are taking place today or in the future
		# this is used on the bookings index
		
		# Bookings on or after today (note from previous midnight onwards so we include parties that already started today
        currentBookings = Booking.where("timeslot >='" + Date.today.to_time.to_s + "'").joins(:city).where("cities.region IN (?)", regions)
            
        dates = Array.new
		
		#get each date that has a booking
		currentBookings.each do |booking| 
			dates << booking.timeslot.to_date
		end
		
		#remove redundant dates and sort in date order
		dates.uniq!
		dates.sort!
	end
  
  def no_guests(date = Time.now) # the number of guests this booking has
    g = 0
    if self.invoices.empty?
      g = self.guest.number
    else
      # go through each invoice, and their line items and add their no_guests
      self.invoices.each do |i|
        i.line_items.where("entry_date <= ?", date).each do |l|
          g += l.no_guests unless l.no_guests.nil?
        end
      end
    end
    g
  end
  
  def amount # the total outstanding balance the customer needs to pay
    a = 0
    self.invoices(true).each do |i| #'true' reloads from db, otherwise out of date cache is used. (problem when invoices are programatically created)
      a += i.amount unless i.amount.nil?
    end
    a
  end
  
  def price_per_guest
    p = 0
    self.invoices.each do |i|
      i.line_items.each do |l|
        p += l.price_per_guest unless l.price_per_guest.nil?
      end
    end
    p
  end
  
  def has_guest_discount?
    guest_discount_index == 1
  end
  
  def has_guest_discount_removal?
    guest_discount_index == -1
  end
  
  #def has_eb_discount_expiry?
  #  h = false
  #  expiries = Array.new
    # need to force a database query because the local variable may not be up to date (can't just use "discount_expiry_line_items")
  #  invoices.each do |i|
  #      expiries += DiscountExpiryLineItem.where(:invoice_id => i.id) # array of arrays
  #  end
  #  expiries.flatten.each do |d|
  #    h = true if d.note == DiscountExpiryLineItem::EARLY_BIRD_EXPIRY_NOTE
  #  end
  #  h
  #end
  
  def active_eb_discount # returns the latest eb discount, even if it's expired, unless there's an eb guest removal or expiry
    active_eb_discount = nil
    
    if last_eb_discount = early_bird_discount_line_items.order(:entry_date).last
      # there is an eb discount. are there eb removals?
      if early_bird_discount_removal_line_items.any? # this only checks if was was removed because there were too few guests
        # is the last eb after the last eb removal?
        if last_eb_discount.entry_date > early_bird_discount_removal_line_items.order(:entry_date).last.entry_date
          # then it is active, so return it
          active_eb_discount = last_eb_discount
        else # it's been removed so it's not active. return nil
          active_eb_discount = nil
        end
      else # no eb removals. check for expiry line items
        if (last_expiry = discount_expiry_line_items.order(:entry_date).last) and last_expiry.description == DiscountExpiryLineItem::EB_DISCOUNT_EXPIRY_DESCRIPTION and last_expiry.entry_date > last_eb_discount.entry_date
          active_eb_discount = nil
        else # no expiries, or expiry is for a prev eb discount
          active_eb_discount = last_eb_discount
        end
      end
    else # no eb discounts, so return nil
      active_eb_discount = nil
    end
    active_eb_discount
  end
    
  def deposit_paid?
    total_deposit_amount = 0
    invoices.each do |i|
      i.deposit_payment_line_items.each do |d|
        total_deposit_amount += d.amount
      end
    end

    total_deposit_amount.abs >= (amount / 2)
  end
  
  def active_min_guests_surcharge
    if latest_surcharge = min_guests_surcharge_line_items.order(:entry_date).last
      if latest_removal = min_guests_surcharge_removal_line_items.order(:entry_date).last
        if latest_removal.entry_date < latest_surcharge.entry_date
          latest_surcharge
        else
          nil
        end
      else
        latest_surcharge
      end
    else
      nil
    end
  end
  
  private  
  def guest_discount_index
    # positive number means has guest discount, negative number means has guest discount removal
    num_guest_discounts = 0
    invoices.each do |i|
        num_guest_discounts += i.guest_discount_line_items.count
        num_guest_discounts -= i.guest_discount_removal_line_items.count
    end
    
    raise "A booking can not have more than one guest discount" if num_guest_discounts > 1
    raise "A booking can not have a guest discount removal without a guest discount" if num_guest_discounts < 0
    
    num_guest_discounts
  end
end
