class Studio < ActiveRecord::Base
  belongs_to :venue
  has_many :suggested_slot
  has_many :booking
  
  validates_presence_of :name
  
	def to_s
		to_string
	end
	
	def to_string
		name + " at " + venue.to_s
	end
end
