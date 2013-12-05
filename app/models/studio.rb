class Studio < ActiveRecord::Base
  belongs_to :venue
  has_many :suggested_slot
  has_many :booking
  
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
	
	def self.in_city(city)
		if city.nil?
			Studio.all
		else
			Studio.find_all_by_venue_id(Venue.where(city_id: city.id).pluck(:id))
		end
	end
end
