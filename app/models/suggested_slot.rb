class SuggestedSlot < ActiveRecord::Base
  belongs_to :studio
  validates_presence_of :time
end
