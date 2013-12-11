class Event < ActiveRecord::Base
	belongs_to :booking
	
    # WARNING these actions are stored as string in the DB, and views use them for view logic. So if the string changes, the views get messed up.
    # Recommend implementing an Actions table with name, colour and id, and then adding action_id to the Event table.
	ACTIONS = [
		'Done (green)',
		'Waiting (yellow)',
		'Chase later (blue)',
		'Action required now (red)',
        'None'
	]
	
	validates_inclusion_of :action, :in => ACTIONS, :message => "{{value}} must be in #{ACTIONS.join ','}", :allow_nil => true
	
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
