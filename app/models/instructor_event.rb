class InstructorEvent < Event
  CODES = [
		'Need to book instructor',
		'Instructor invited',
		'Instructor accepted',
		'Instructor declined',
		'Job sheet sent',
		'Job sheet read'
	]
	
		validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}"
end