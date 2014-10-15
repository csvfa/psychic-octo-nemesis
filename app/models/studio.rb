class Studio < ActiveRecord::Base
  belongs_to :venue
  has_many :suggested_slots, :dependent => :destroy
  has_many :bookings
  has_many :availability_slots, :dependent => :destroy
    
  accepts_nested_attributes_for :suggested_slots, :allow_destroy => true
  accepts_nested_attributes_for :availability_slots, :allow_destroy => true
  
    validates_presence_of :name
    
    def to_s
		to_string
	end
	
	def to_string
        if name=="Default" then
            venue.to_s
        else
            name + " at " + venue.to_s
        end
	end
		
	def available_at?(slot)
		#true if the given timeslot is within the studio's available to/from times
		slot_flattened_date = slot.change(:year => 2000, :month => 1, :day => 1)
		
		(slot_flattened_date >= available_from) && (slot_flattened_date <= available_to)
	end
		
	def within_a_suggested_slot?(time)
		#true if the given time is within the two hour span of a suggested slot
		
		is_within = false
		time_flattened_date = time.change(:year => 2000, :month => 1, :day => 1)
		
		suggested_slots.each do |suggested_slot|
			is_within = true if time_flattened_date.between?(suggested_slot.time, suggested_slot.time + 2.hours)
		end
		
		is_within
	end
				
	
    # returns all studios in the given city, sorted by venue. always include "own venue".
    def self.in_city(city)
        if city.nil?
            Studio.joins(:venue).order('venues.name')
        else
            ownVenue = Studio.joins(:venue).where("venues.name = 'Own venue'")
            if ownVenue.nil?
                Studio.joins(:venue).order('venues.name').find_all_by_venue_id(Venue.where(city_id: city.id).pluck(:id))
            else
                Studio.joins(:venue).order('venues.name').find_all_by_venue_id(Venue.where(city_id: city.id).pluck(:id)) + ownVenue
            end
        end
    end
end