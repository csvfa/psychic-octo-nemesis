class City < ActiveRecord::Base
	has_and_belongs_to_many :coaches
	has_many :venues
end
