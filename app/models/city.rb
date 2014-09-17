class City < ActiveRecord::Base
	REGIONS = [
		'North',
		'South',
		'East',
		'West',
        'Unknown'
	]
	
	has_and_belongs_to_many :coaches
	has_many :bookings
	has_many :venues
	
	validates_inclusion_of :region, :in => REGIONS, :message => "{{value}} must be in #{REGIONS.join ','}"

	def to_s
		name
	end
end
