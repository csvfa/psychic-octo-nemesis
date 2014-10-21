class Booking < ActiveRecord::Base
  has_one :guest, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_one :invoice, :dependent => :destroy
  
  belongs_to :theme
  belongs_to :coach
  belongs_to :studio
  belongs_to :customer
  belongs_to :sales_person
  belongs_to :city
  belongs_to :pricing_structure
	
  accepts_nested_attributes_for :guest
  accepts_nested_attributes_for :customer
  
  ENQUIRY_METHODS = [
    'Telephone',
    'Email',
    'Social media'
  ]
	
  validates_inclusion_of :enquiry_method, :in => ENQUIRY_METHODS, :message => "{{value}} must be in #{ENQUIRY_METHODS.join ','}", :allow_nil => true

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
		# returns all bookings in a given array of regions, for a given day, in order of timeslot. also accepts a nil date, and will return nil timeslots in order of record creation
        # need to then order by city (north to south), and then by time
        if date.nil?
          Booking.where(timeslot: nil).joins(:city).where("cities.region IN (?)", regions).order('latitude DESC', 'created_at')
        else
          Booking.where(timeslot: date.midnight..(date.midnight + 1.day)).joins(:city).where("cities.region IN (?)", regions).order('latitude DESC', 'timeslot')
        end
	end
	
	def self.in_timeslot(slot, studio, city = nil)
		#returns all bookings on the given date, between the given time and 14 minutes after it, in the given studio
		if studio.nil?
			Booking.where(timeslot: slot..(slot + 14.minutes)).where(studio_id: nil).order('timeslot')
		else
			Booking.where(timeslot: slot..(slot + 14.minutes)).where(studio_id: studio.id).order('timeslot')
		end
	end
	
  def self.dates_of_current_bookings(regions)
    # Bookings on or after today (note from previous midnight onwards so we include parties that already started today
    dates_of_bookings(current_bookings_in_region(regions))
  end
  
  def self.dates_of_balance_due_bookings(regions)
    dates_of_bookings(current_bookings_in_region(regions).select { |booking| booking.invoice && booking.invoice.amount_outstanding != 0 && booking.invoice.balance_due_date <= Date.today })
  end
  
  def self.dates_of_deposit_due_bookings(regions)
    dates_of_bookings(current_bookings_in_region(regions).select { |booking| booking.invoice && !booking.invoice.deposit_paid? && booking.invoice.deposit_due_date <= Date.today })
  end
  
  def no_guests
    guest.number
  end
  
  private
  
  def self.dates_of_bookings(bookings)
    dates = Array.new
		
    bookings.each do |booking|
      dates << booking.timeslot.to_date if booking.timeslot.present?
    end
		
    dates.uniq!
    dates.sort!
  end
  
  def self.current_bookings_in_region(regions)
    Booking.where("timeslot >='" + Date.today.to_time.to_s + "' OR timeslot IS NULL").joins(:city).where("cities.region IN (?)", regions)
  end
end