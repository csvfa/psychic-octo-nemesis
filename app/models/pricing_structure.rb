class PricingStructure < ActiveRecord::Base
  has_many :bookings
  validates :min_cost, :presence => true
  validates :rate_per_person, :presence => true
end
