class Booking < ActiveRecord::Base
	has_many :guests
	has_many :events

	belongs_to :theme
	belongs_to :coach
	belongs_to :studio
	belongs_to :customer

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
end
