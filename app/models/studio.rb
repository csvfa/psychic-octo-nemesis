class Studio < ActiveRecord::Base
    belongs_to :venue
    has_many :suggested_slots, :dependent => :destroy
    has_many :bookings
    
    accepts_nested_attributes_for :suggested_slots, :allow_destroy => true
  
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