class Booking < ActiveRecord::Base
	has_one :guest, :dependent => :destroy
	has_many :events, :dependent => :destroy
    has_many :invoices, :dependent => :destroy

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

	def guest_number
		if guests.empty?
			g = guests.build :number => 0
			g.save
			g
		else
			guests.last
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
  
  def current_no_guests
    # return the guest no of the latest line item. if there are no no line items, return .guest. if that doesn't exist, nil
    current_no_guests = 0
    all_invoices = invoices.all
    no_guest_line_items = []
    
    if all_invoices.present?
      all_invoices.each do |i|
          no_guest_line_items += i.line_items.where("no_guests NOT NULL")
      end
      no_guest_line_items.sort! { |a,b| a.entry_date <=> b.entry_date }
    end
    
    if !no_guest_line_items.empty?
      current_no_guests = no_guest_line_items.last.no_guests
    else
      current_no_guests = guest.number unless guest.nil?
    end
    
    current_no_guests
  end
end
