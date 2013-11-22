class Event < ActiveRecord::Base
	belongs_to :booking
  belongs_to :imageable, :polymorphic => true #this allows the model to 'belong to' multiple models. Is this needed? Event just belongs to Booking.
  
  CODES = [
		'Enquiry received',
		'Enquiry response sent',
		'Chased',
		'Question received',
		'Answer sent',
		'Customer wants to pencil',
		'Pencil confirmation sent',
		'Pencil expired',
		'Customer wants to book',
		'Booking form & invoice sent',
		'Deposit overdue, no longer holding',
		'Deposit received, awaiting form',
		'Booking form has no phone number',
		'Form & deposit received & confirmation sent',
		'Cheer info requested',
		'Cheer info received',
		'Customer wants to add guests',
		'Customer wants to remove guests',
		'Credit note raised',
		'Additional invoice sent',
		'Additional payment received',
		'Balance reminder sent',
		'Balance overdue - Monday reminder',
		'Balance overdue - Wednesday reminder',
		'Balance overdue - Friday cancellation',
		'Balance paid',
		'Final confirmation sent',
		'Need to book instructor',
		'Instructor invited',
		'Instructor accepted',
		'Instructor declined',
		'Studio need to pencil',
		'Studio pencilled',
		'Studio need to book',
		'Studio booked',
		'Job sheet sent',
		'Job sheet read',
		'Party completed',
		'Post party email sent',
		'Feedback received',
		'Customer cancels & feedback requested',
		'Cancellation feedback received',
		'CC cancels booking',
		'Murkified'
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
