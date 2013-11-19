class Customer < ActiveRecord::Base
	has_many :bookings
	has_many :events, :as => :imageable
	
	validates_presence_of :name
	
	def to_s
		name
	end
end
