class BookingEvent < Event
	CODES = [
		'Enquiry received',
		'Enquiry response sent',
		'Chased',
		'Question received',
		'Answer sent',
        'Comment received',
		'Customer wants to pencil',
		'Pencil confirmation sent',
		'Pencil expired',
		'Customer wants to book',
		'Booking form sent',
        'Booking form received',
		'Booking form has no phone number',
		'Cheer info requested',
		'Cheer info received',
		'Customer wants to add guests',
		'Customer wants to remove guests',
		'Final confirmation sent',
		'Party completed',
		'Post party email sent',
		'Feedback received',
		'Customer cancels & feedback requested',
		'Cancellation feedback received',
		'CC cancels booking',
		'Murkified'
	]
	
		validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}", :allow_nil => true
end
