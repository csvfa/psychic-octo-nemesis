class BookingEventsController < ApplicationController
  def new
    @booking = Booking.find(params["booking_id"])
    @booking_event = BookingEvent.new(:booking => @booking)
		
    # record where the user came from so we can return them there after the save
    session[:return_to] ||= request.referer 
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @booking_event }
    end
	end
	
  def edit
    # record where the user came from so we can return them there after the save
    session[:return_to] ||= request.referer
		
    @booking_event = BookingEvent.find(params[:id])
    @booking = @booking_event.booking
  end
		
  def create
    @booking_event = BookingEvent.new(params[:booking_event])
				
    #We need to instantiate the @booking variable in case there's a save error, because the "new" view uses it
    @booking = @booking_event.booking
        
    return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s

    respond_to do |format|
      if @booking_event.save
        create_invoice_if_needed
        format.html { redirect_to return_path, :notice => 'Booking note was successfully created.' }
        format.json { render :json => @booking_event, :event => :created, :location => @booking_event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @booking_event.errors, :event => :unprocessable_entity }
      end
    end
  end
	
  def update
    @booking_event = BookingEvent.find(params[:id])
    @booking = @booking_event.booking
      
    return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s

    respond_to do |format|
      if @booking_event.update_attributes(params[:booking_event])
        create_invoice_if_needed
        format.html { redirect_to return_path, :notice => 'Booking Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @booking_event.errors, :event => :unprocessable_entity }
      end
    end
	end
	
  def destroy
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    @booking_event = BookingEvent.find(params[:id])
        
    return_path = session.delete(:return_to) + "#booking" + @booking_event.booking.id.to_s
        
    @booking_event.destroy

    respond_to do |format|
      format.html { redirect_to return_path, :notice => 'Booking event was deleted.' }
      format.json { head :no_content }
    end
  end
  
  private
  def create_invoice_if_needed
    create_invoice if @booking_event.code == 'Customer wants to book' and @booking.invoices.empty? and @booking.no_guests > 0
  end
  
  def create_invoice
    i = Invoice.new
    i.booking = @booking
    i.invoice_date = Date.today
    i.set_default_dates
    raise "Invoice creation had the following errors: " + i.errors.to_s unless i.save
        
    p = PartyLineItem.new
    p.description = LineItem::TYPE_DESCRIPTIONS["party"]
    p.entry_date =  Time.now.round
    p.no_guests =   i.booking.no_guests
    p.invoice =     i
    p.calculate_and_set_variables
    raise "Party Line Item creation had the following errors: " + p.errors.to_s unless p.save
    
    if i.booking.no_guests >= EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_GUEST_NUMBER_THRESHOLD
      ed =                 EarlyBirdDiscountLineItem.new
      ed.description =     EarlyBirdDiscountLineItem::DESCRIPTION
      ed.invoice =         i
      ed.entry_date =      Time.now.round
      ed.expiry_date =     ed.default_expiry_date
      ed.note =            EarlyBirdDiscountLineItem::NOTE
      ed.price_per_guest = EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_PRICE_PER_PERSON
      ed.calculate_and_set_variables
      raise "Early Bird Discount Line Item creation had the following errors: " + ed.errors.to_s unless ed.save
    end
  end
end
