class Guest < ActiveRecord::Base
	belongs_to :booking
  
	def to_string
  		number
  	end
end
