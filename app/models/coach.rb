class Coach < ActiveRecord::Base
  has_and_belongs_to_many :cities
  has_many :events, :as => :imageable
  
  def full_name
    if first_name.present?
      if surname.present?
        first_name + " " + surname
      else
        first_name
      end
    else
      surname
    end
  end
end
