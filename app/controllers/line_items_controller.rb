class LineItemsController < ApplicationController

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @invoice = Invoice.find(params[:invoice_id])
    @label_prefix = ""

    # set type-specific variables (in hindsight maybe better to use each subclasses' controllers but share a view?)
    set_new_line_item_variables
    
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end
    
  

  # GET /line_items/1/edit
  def edit
    set_edit_line_item_variables 
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
  end

  # POST /line_items
  # POST /line_items.json
  def create
    set_create_line_item_variables
    
    respond_to do |format|
      if @line_item.save
        format.html { redirect_to session.delete(:return_to), notice: 'Line item was successfully created.' }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    set_update_line_item_variables
    
    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to session.delete(:return_to), notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.json { head :no_content }
    end
  end
  
  def set_new_line_item_variables
    case params[:line_item_type]
      when "party"
        @line_item = PartyLineItem.new
        @expiry_date_state = "disabled"
      when "guest_change"
        @line_item = GuestChangeLineItem.new
        @expiry_date_state = @amount_state = "disabled"
        @label_prefix = "Change in "
      when "early_bird_discount"
        @line_item = EarlyBirdDiscountLineItem.new
        @no_guests_state = @amount_state = "disabled"
        @line_item.price_per_guest = EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_PRICE_PER_PERSON
        @line_item.expiry_date = EarlyBirdDiscountLineItem.early_bird_offer_default_expiry_date
        @label_prefix = "Change in "
      when "fixed_discount"
        @line_item = FixedDiscountLineItem.new
        @no_guests_state = "disabled"
        @price_per_guest_state = "disabled"
        @label_prefix = "Change in "
      when "ppg_discount"
        @line_item = PPGDiscountLineItem.new
        @no_guests_state = "disabled"
        @amount_state = "disabled"
        @label_prefix = "Change in "
      when "refund"
        @line_item = RefundLineItem.new
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"
        @label_prefix = "Change in "
      when "deposit_payment"
        @line_item = DepositPaymentLineItem.new
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"  
        @label_prefix = "Change in "
      when "balance_payment"
        @line_item = BalancePaymentLineItem.new
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"      
        @label_prefix = "Change in "
    end
    
    @line_item.type = @line_item.class.to_s
    @line_item.invoice = @invoice
    @line_item.description = LineItem::TYPE_DESCRIPTIONS[params["line_item_type"]]
  end
    
  def set_edit_line_item_variables
 @label_prefix = ""
    
    case LineItem.find(params[:id]).type
      when "PartyLineItem"
        @line_item = PartyLineItem.find(params[:id])
        @expiry_date_state = "disabled"
      when "GuestChangeLineItem"
        @line_item = GuestChangeLineItem.find(params[:id])
        @expiry_date_state = "disabled"
        @label_prefix = "Change in "
      when "EarlyBirdDiscountLineItem"
        @line_item = EarlyBirdDiscountLineItem.find(params[:id])
        @no_guests_state = @amount_state = "disabled"
        @label_prefix = "Change in "
      when "EarlyBirdDiscountRemovalLineItem"
        @line_item = EarlyBirdDiscountRemovalLineItem.find(params[:id])
        @no_guests_state = @amount_state = "disabled"
        @label_prefix = "Change in "
      when "GuestDiscountLineItem"
        @line_item = GuestDiscountLineItem.find(params[:id])
        @no_guests_state = "disabled"
        @label_prefix = "Change in "
      when "GuestDiscountRemovalLineItem"
        @line_item = GuestDiscountRemovalLineItem.find(params[:id])
        @no_guests_state = "disabled"
        @label_prefix = "Change in "
      when "FixedDiscountLineItem"
        @line_item = FixedDiscountLineItem.find(params[:id])
        @no_guests_state = "disabled"
        @price_per_guest_state = "disabled"
        @label_prefix = "Change in "
      when "PPGDiscountLineItem"
        @line_item = PPGDiscountLineItem.find(params[:id])
        @no_guests_state = @amount_state =  "disabled"
        @label_prefix = "Change in "
      when "DiscountExpiryLineItem"
        @line_item = DiscountExpiryLineItem.find(params[:id])
        @no_guests_state = "disabled"
        @note_state = "disabled"
        @label_prefix = "Change in "
      when "RefundLineItem"
        @line_item = RefundLineItem.find(params[:id])
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"
        @label_prefix = "Change in "
      when "DepositPaymentLineItem"
        @line_item = DepositPaymentLineItem.find(params[:id])
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"  
        @label_prefix = "Change in "
      when "BalancePaymentLineItem"
        @line_item = BalancePaymentLineItem.find(params[:id])
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"  
        @label_prefix = "Change in "
      when "MinGuestsSurchargeLineItem"
        @line_item = MinGuestsSurchargeLineItem.find(params[:id])
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"  
        @label_prefix = "Change in "
      when "MinGuestsSurchargeRemovalLineItem"
        @line_item = MinGuestsSurchargeRemovalLineItem.find(params[:id])
        @no_guests_state = @expiry_date_state = @price_per_guest_state = "disabled"  
        @label_prefix = "Change in "
    end
    
    @invoice = @line_item.invoice
  end
    
  def set_create_line_item_variables
    case params["line_item"]["type"]
      when "PartyLineItem"
        @line_item = PartyLineItem.new(params[:line_item])
      when "GuestChangeLineItem"
        @line_item = GuestChangeLineItem.new(params[:line_item])
      when "EarlyBirdDiscountLineItem"
        @line_item = EarlyBirdDiscountLineItem.new(params[:line_item])
      when "FixedDiscountLineItem"
        @line_item = FixedDiscountLineItem.new(params[:line_item])
      when "PPGDiscountLineItem"
        @line_item = PPGDiscountLineItem.new(params[:line_item])
      when "RefundLineItem"
        @line_item = RefundLineItem.new(params[:line_item])
      when "DepositPaymentLineItem"
        @line_item = DepositPaymentLineItem.new(params[:line_item])
      when "BalancePaymentLineItem"
        @line_item = BalancePaymentLineItem.new(params[:line_item])
    end
  end
    
  def set_update_line_item_variables
    case params["line_item"]["type"]
      when "PartyLineItem"
        @line_item = PartyLineItem.find(params[:id])
      when "GuestChangeLineItem"
        @line_item = GuestChangeLineItem.find(params[:id])
      when "EarlyBirdDiscountLineItem"
        @line_item = EarlyBirdDiscountLineItem.find(params[:id])
      when "EarlyBirdDiscountRemovalLineItem"
        @line_item = EarlyBirdDiscountRemovalLineItem.find(params[:id])
      when "GuestDiscountLineItem"
        @line_item = GuestDiscountLineItem.find(params[:id])
      when "GuestDiscountRemovalLineItem"
        @line_item = GuestDiscountRemovalLineItem.find(params[:id])
      when "FixedDiscountLineItem"
        @line_item = FixedDiscountLineItem.find(params[:id])
      when "PPGDiscountLineItem"
        @line_item = PPGDiscountLineItem.find(params[:id])
      when "DiscountExpiryLineItem"
        @line_item = DiscountExpiryLineItem.find(params[:id])
      when "RefundLineItem"
        @line_item = RefundLineItem.find(params[:id])
      when "DepositPaymentLineItem"
        @line_item = DepositPaymentLineItem.find(params[:id])
      when "BalancePaymentLineItem"
        @line_item = BalancePaymentLineItem.find(params[:id])
      when "MinGuestsSurchargeLineItem"
        @line_item = MinGuestsSurchargeLineItem.find(params[:id])
      when "MinGuestsSurchargeRemovalLineItem"
        @line_item = MinGuestsSurchargeRemovalLineItem.find(params[:id])
    end
  end
end