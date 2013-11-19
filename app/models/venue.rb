class Venue < ActiveRecord::Base
  belongs_to :city
  has_many :opening_times
  has_many :studios
  
  def to_s
  	name
  end
end