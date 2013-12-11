class BookingsController < ApplicationController
  # GET /bookings
    
    def index
	# order by city, venue, timeslot, time
	
	# attempt 1 here doesn't work because a booking may not have a studio
	#	@finalSorted = @currentBookings.sort_by
	#		{|x|
	#			[x.studio.venue.city.name,
	#			x.studio.venue.name,
	#			x.timeslot]
	#		}
        
        # if the user previously chose a region, use that. otherwise default to All
        if session[:region].nil?
            @region = "All"
        else
            @region = session[:region]
        end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new
    @themes = Theme.all
    @coaches = Coach.all
    @studios = Studio.all
		@salespeople = SalesPerson.all
		@cities = City.all :order => "latitude DESC"
		
		#Create new customer & guest no. records which will appear in the view
		@booking.customer = Customer.new
		@booking.guest = Guest.new
		
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @booking }
    end
  end

  # GET /bookings/1/edit
    def edit
        @booking = Booking.find(params[:id])
        @themes = Theme.all :order => :name
        @coaches = Coach.all :order => :name
        @studios = Studio.all
        @salespeople = SalesPerson.all
		@cities = City.all :order => "latitude DESC"
		
		if @booking.guest.nil?
			@booking.guest = Guest.new
		end
		
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(params[:booking])
    @themes = Theme.all :order => :name
    @coaches = Coach.all :order => :name
    @studios = Studio.all
    @salespeople = SalesPerson.all
    @cities = City.all :order => "latitude DESC"
      
    if @booking.guest.nil?
        @booking.guest = Guest.new
    end

    respond_to do |format|
      if @booking.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Booking was successfully created.' }
        format.json { render :json => @booking, :event => :created, :location => @booking }
      else
        format.html { render :action => "new" }
        format.json { render :json => @booking.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = Booking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to session.delete(:return_to), :notice => 'Booking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @booking.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), :notice => 'Booking was deleted.' }
      format.json { head :no_content }
    end
  end

    # use for ajax call used by region filter on bookings index.
    def set_region
        @region = params[:region]
        
        # store in session so return to the page later remembers the last selected region
        session[:region] = @region
        
        respond_to do |format|
            format.html { render :partial => "bookings" }
		end
        
        #render :update do |page|
        #    page.replace_html 'bookingsDiv', :partial => 'bookings'
        #end
    end
end
