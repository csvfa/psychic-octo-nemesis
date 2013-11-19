class Studio < ActiveRecord::Base
  belongs_to :venue
  has_many :suggested_slot
  
  validates_presence_of :name
end
