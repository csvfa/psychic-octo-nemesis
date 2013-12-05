class Venue < ActiveRecord::Base
  belongs_to :city
  has_many :opening_times, :dependent => :destroy
  has_many :studios, :dependent => :destroy
    
    accepts_nested_attributes_for :studios
  
  def to_s
  	name
  end
end