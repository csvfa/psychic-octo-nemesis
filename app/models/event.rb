class Event < ActiveRecord::Base
	belongs_to :booking
  #belongs_to :imageable, :polymorphic => true #this allows the model to 'belong to' multiple models. Is this needed? Event just belongs to Booking.
	
	def to_s
		if notes.nil?
			if occurred_at.nil?
				code
			else
				code + " " + occurred_at.to_s(:standard)
			end
		else
			if occurred_at.nil?
				code + " " + notes
			else
				code + " " + notes + " " + occurred_at.to_s(:standard)
			end
		end
	end
end
