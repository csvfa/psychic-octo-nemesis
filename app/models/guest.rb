class Guest < ActiveRecord::Base
	belongs_to :booking
  
	def to_s
		self.number
	end
end
