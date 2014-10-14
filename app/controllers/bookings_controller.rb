class BookingsController < ApplicationController
  helper ApplicationHelper
  # GET /bookings
    
  def index        
    # if the user previously chose a region, use that. otherwise default to all. Set rather than an array so no duplicates.
    if session[:filtered_regions].nil?
      @filtered_regions = Set.new City::REGIONS
    else
      @filtered_regions = Set.new session[:filtered_regions]
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
    @booking = Booking.new(params[:booking])
    @themes = Theme.all
    @coaches = Coach.all
    @studios = Studio.all
    @salespeople = SalesPerson.all
    @cities = City.all :order => "latitude DESC"
    @pricing_structures = PricingStructure.where("expiry_date >= ?", Date.today)
		
    #Create new customer & guest no. records which will appear in the view
    @booking.customer = Customer.new
    @booking.guest = Guest.new
    @booking.guest.number = 0 # default is 0, which we treat as meaning "unspecified". Invoicing etc is disabled when it is 0
        
    @booking.city = City.find_all_by_name(:Unspecified).last
		
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
    @coaches = Coach.all :order => :first_name
    @studios = Studio.all
    @salespeople = SalesPerson.all
    @cities = City.all :order => "latitude DESC"
    @pricing_structures = PricingStructure.where("expiry_date >= ?", Date.today)
		
    if @booking.guest.nil?
      @booking.guest = Guest.new
    end
    
    @booking.city = City.find_all_by_name(:Unspecified).last if @booking.city.nil?
		
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(params[:booking])
    @themes = Theme.all :order => :name
    @coaches = Coach.all :order => :first_name
    @studios = Studio.all
    @salespeople = SalesPerson.all
    @cities = City.all :order => "latitude DESC"

    @booking.city = City.find_all_by_name(:Unspecified).last if @booking.city.nil?
      
    if @booking.guest.nil?
        @booking.guest = Guest.new
    end
    
    respond_to do |format|
      if @booking.save
        if session[:return_to].nil?
          return_path = root_path
        else
          return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s
        end
        format.html { redirect_to return_path, :notice => 'Booking was successfully created.' }
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
    @booking.city = City.find_all_by_name(:Unspecified).last if @booking.city.nil?
    
	if session[:return_to].nil?
      return_path = root_path
    else
      return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s
    end

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to return_path, :notice => 'Booking was successfully updated.' }
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
  def set_filtered_regions
    @filtered_regions = Set.new session[:filtered_regions]
        
    if params[:add] == "true"
      @filtered_regions.add params[:region]
    else
      @filtered_regions.delete params[:region]
    end
        
    # store in session so return to the page later remembers the last selected region
    session[:filtered_regions] = @filtered_regions
        
    respond_to do |format|
      format.html { render :partial => "bookings" }
    end
  end
	
  def studio_calendar
    @booking = Booking.find(params[:id])
    @city = @booking.city
    @date = @booking.timeslot
    @studios = Studio.in_city(@city)
    @cells_to_be_skipped_because_rowspan_is_annoying = Hash.new(0)
  end
	
  def booking_form
    @booking = Booking.find(params[:id])
    @customer = @booking.customer
    @venue = @booking.studio.venue
  end
  
  def job_sheet
    @booking = Booking.find(params[:id])
    
    if @booking.coach.cities.include? @booking.city
      @fee = "£50"
      @travel = "No travel"
    else
      @fee = "[Fee]"
      @travel = "Travel: £ [Travel]"
    end
    
    @studio_price_to_display = ""
    @booking.events.where(:type => "StudioEvent").each do |event|
       @studio_price_to_display = "Studio price: " + number_to_currency(@booking.studio.price, unit: "&pound;") if event.code == 'Instructor to pay on the day'
    end
  end
  
  def create_and_show_invoice(booking)
    invoice = Invoice.new
    invoice.version_number = 1
    invoice.booking = booking
    invoice.set_default_dates
    
    if invoice.save
      create_first_line_item unless booking.pricing_structure.rate_per_person.nil?
        format.html { redirect_to invoice_path(invoice.id), notice: 'Invoice was successfully created.' }
        format.json { render json: invoice, status: :created, location: invoice }
    else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
    end
  end
end