class PaymentEvent < Event
  CODES = [
		'Need to send invoice',
		'Invoice sent, awaiting pay',
		'Deposit overdue, no longer holding',
		'Deposit received',
		'Form & deposit received & confirmation sent',
		'Credit note raised',
		'Additional invoice sent',
		'Additional payment received',
		'Balance reminder sent',
		'Balance overdue - Monday reminder',
		'Balance overdue - Wednesday reminder',
		'Balance overdue - Friday cancellation',
		'Balance paid'
	]
	
		validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}", :allow_nil => true
end
