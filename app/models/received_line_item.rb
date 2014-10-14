class ReceivedLineItem < ActiveRecord::Base
  belongs_to :invoice
end