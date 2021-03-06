class InstructorEvent < Event
  CODES = [
		'Need to book instructor',
		'Instructor invited',
		'Instructor accepted',
		'Instructor declined',
        'Cheer info for job sheet',
        'Job sheet note',
        'Job sheet sent',
		'Job sheet read',
		'Kit pending',
		'Kit allocated',
        'Other'
	]
	
		validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}", :allow_nil => true
end
