class LineItem < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :type, :entry_date, :price_per_guest, :amount, :note, :expiry_date, :invoice_id, :no_guests, :action, :description # did this because I was getting MassAssignmentSecurity errors when creating new line items. Not too sure why.
  
  TYPE_DESCRIPTIONS = {
    "party" => "Party",
    "discount" => "Discount",
    "guest_change" => "Guest change",
    "refund" => "Refund",
    "deposit_payment" => "Deposit payment",
    "balance_payment" => "Balance Payment"
  }
  
  def calculate_and_set_amount
    # unless implemented by a subclass, this method doesn't do anything - the amount is just the amount
  end
  
  def calculate_and_set_price_per_guest
      # unless implemented by a subclass, this method doesn't do anything - price_per_guest is not used by all subclasses
  end
  
  def self.latest_with_num_guests(line_item)
    #return the line item before the supplied one (in the same invoice) that has a no guests.
    line_item.invoice.line_items.order(:entry_date).where("no_guests NOT NULL").last
  end
  
  # this makes form_for work for subclasses. for details, see http://stackoverflow.com/questions/5107386/single-controller-multiple-inherited-classes-rails-3
  def self.inherited(child)  
    child.instance_eval do
      def model_name
        LineItem.model_name
      end
    end
    super 
  end
end
