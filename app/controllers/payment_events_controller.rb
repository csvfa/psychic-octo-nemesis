class PaymentEventsController < ApplicationController
  def new
    @booking = Booking.find(params["booking_id"])
    @payment_event = PaymentEvent.new(:booking => @booking)
		
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer 
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payment_event }
    end
	end
		
	def create
    @payment_event = PaymentEvent.new(params[:payment_event])
				
		#We need to instantiate the @booking variable in case there's a save error, because the "new" view uses it
		@booking = @payment_event.booking
        
        return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s

    respond_to do |format|
      if @payment_event.save
        format.html { redirect_to return_path, :notice => 'Payment note was successfully created.' }
        format.json { render :json => @payment_event, :event => :created, :location => @payment_event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @payment_event.errors, :event => :unprocessable_entity }
      end
    end
  end
	
  def edit
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer
		
    @payment_event = PaymentEvent.find(params[:id])
    @booking = @payment_event.booking
  end
	
  def update
    @payment_event = PaymentEvent.find(params[:id])
		@booking = @payment_event.booking
      
      return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s

    respond_to do |format|
      if @payment_event.update_attributes(params[:payment_event])
        format.html { redirect_to return_path, :notice => 'Payment note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @payment_event.errors, :event => :unprocessable_entity }
      end
    end
	end
	
	def destroy
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    @payment_event = PaymentEvent.find(params[:id])
        
        return_path = session.delete(:return_to) + "#booking" + @payment_event.booking.id.to_s
        
    @payment_event.destroy

    respond_to do |format|
      format.html { redirect_to return_path, :notice => 'Payment note was deleted.' }
      format.json { head :no_content }
    end
  end
end