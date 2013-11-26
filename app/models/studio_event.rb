class StudioEvent < Event
  CODES = [
		'Studio need to pencil',
		'Studio pencilled',
		'Studio need to book',
		'Studio booked'
	]
		validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}"
end
