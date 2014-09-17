class LineItem < ActiveRecord::Base

  belongs_to        :invoice
  
  attr_accessible   :type, :entry_date, :price_per_guest, :amount, :note, :expiry_date, :invoice_id, :no_guests, :action, :description # did this because I was getting MassAssignmentSecurity errors when creating new line items. Not too sure why.
  
  before_validation :calculate_and_set_variables
  after_save        :update_later_line_items      # because this new line item may have knock on effects on later ones.
  after_destroy     :update_later_line_items 
  
  TYPE_DESCRIPTIONS = {
    "party" => "Party",
    "ppg_discount" => "Price Per Guest Discount",
    "fixed_discount" => "Fixed Discount",
    "early_bird_discount" => "Early Bird Offer",
    "guest_discount" => "Guest Discount",
    "guest_change" => "Guest change",
    "refund" => "Refund",
    "deposit_payment" => "Deposit payment",
    "balance_payment" => "Balance Payment"
  }
  
  # this makes form_for work for subclasses. for details, see http://stackoverflow.com/questions/5107386/single-controller-multiple-inherited-classes-rails-3
  def self.inherited(child)  
    child.instance_eval do
      def model_name
        LineItem.model_name
      end
    end
    super 
  end
  
  def calculate_and_set_variables
    #subclasses use this
  end
  
  def update_later_line_items
    invoice.booking.invoices.each do |i|
      i.line_items.where("entry_date > ?", entry_date).each do |l|
        l.calculate_and_set_variables
        l.save # this calls update later line items
      end
    end
  end
end