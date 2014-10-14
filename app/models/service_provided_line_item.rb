class ServiceProvidedLineItem < ActiveRecord::Base
  belongs_to :invoice
  validates :rate_per_person, numericality: { greater_than: 0 }
  before_save :calculate_amount, if: Proc.new { |line_item| line_item.amount.nil? }
  
  def calculate_amount
    self.amount = no_people * rate_per_person unless no_people.nil? || rate_per_person.nil? 
  end
end