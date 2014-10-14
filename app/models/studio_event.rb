class StudioEvent < Event
  CODES = [
    'Studio need to pencil',
    'Studio pencilled',
    'Studio need to book',
    'Studio booked',
    'Instructor to pay on the day',
    'Awaiting invoice',
    'Need to pay',
    'Studio paid',
    'Need to cancel',
    'Cancelled',
    'Job sheet note',
    'Other']
  
  validates_inclusion_of :code, :in => CODES, :message => "{{value}} must be in #{CODES.join ','}", :allow_nil => true
end
