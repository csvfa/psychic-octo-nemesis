class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @invoice = Invoice.find(params[:invoice_id])
    @label_prefix = ""
    @display_before_values? = true
    
    # set type-specific variables (in hindsight maybe better to use each subclasses' controllers but share a view?)
    case params[:line_item_type]
      when "party"
        @line_item = PartyLineItem.new
        @expiry_date_state = "disabled"
        @display_before_values? = false
      when "guest_change"
        @line_item = GuestChangeLineItem.new
        @expiry_date_state = @amount_state = "disabled"
        @label_prefix = "Change in "
      when "discount"
        @line_item = DiscountLineItem.new
        @no_guests_state = "disabled"
        @line_item.price_per_guest = DiscountLineItem::EARLY_BIRD_OFFER_PRICE_PER_PERSON
        @line_item.expiry_date = DiscountLineItem.early_bird_offer_default_expiry_date
        @line_item.note = "Early bird offer"
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


    
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end
    
  

  # GET /line_items/1/edit
  def edit
    
    @label_prefix = ""
    
    case LineItem.find(params[:id]).type
      when "PartyLineItem"
        @line_item = PartyLineItem.find(params[:id])
        @expiry_date_state = "disabled"
      when "GuestChangeLineItem"
        @line_item = GuestChangeLineItem.find(params[:id])
        @expiry_date_state = "disabled"
        @label_prefix = "Change in "
      when "DiscountLineItem"
        @line_item = DiscountLineItem.find(params[:id])
        @no_guests_state = "disabled"
        @label_prefix = "Change in "
        logger.debug "in case: @label_prefix is " + @label_prefix
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
    end
    
    @invoice = @line_item.invoice
    
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = LineItem.new(params[:line_item])
    
    # calculate any system-determined variables (ones the user doesn't enter)
    @line_item.calculate_and_set_variables
    
    # update invoice and booking variables
    # @invoice.booking.update_no_guests(@line_item.invoice)
    # @invoice.update_invoice_variables(@line_item)
  

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
    @line_item = LineItem.find(params[:id])

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
end
