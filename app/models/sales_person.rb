class SalesPerson < ActiveRecord::Base
	has_many :bookings
  belongs_to :events_company
	
	def to_s
		if events_company.nil?
			name
		else
			name + " (" + events_company.name + ")"
		end
	end
end
