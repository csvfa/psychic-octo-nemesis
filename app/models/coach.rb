class Coach < ActiveRecord::Base
  has_and_belongs_to_many :cities
  has_many :events, :as => :imageable
end
