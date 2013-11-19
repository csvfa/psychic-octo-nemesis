class Event < ActiveRecord::Base
	belongs_to :booking
  belongs_to :imageable, :polymorphic => true
  
  CODES = [
		'Enquiry received',
		'Quote sent',
		'Murkified',
		'Chased',
		'Question received',
		'Answer sent',
		'Request to book received',
		'Booking form & invoice sent',
		'Coach booked',
		'Venue pencilled',
		'Venue booked',
		'Job sheet sent',
		'Job sheet read',
		'Form & deposit received',
		'Balance reminder sent',
		'Balance paid',
		'Final confirmation sent',
		'Party completed',
		'Post party email sent',
		'Feedback received'
	]
	
	validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}"
	
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
