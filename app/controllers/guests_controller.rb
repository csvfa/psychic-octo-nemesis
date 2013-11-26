class GuestsController < ApplicationController
  # GET /guests
  # GET /guests.json
  def index
    @guests = Guest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @guests }
    end
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
    @guest = Guest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @guest }
    end
  end

  # GET /guests/new
  # GET /guests/new.json
  def new
  	@booking = Booking.find(params[:booking_id])
    @guest = Guest.new(:booking => @booking, :number => params[:number])
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @guest }
    end
  end

  # GET /guests/1/edit
  def edit
  	@booking = Booking.find(params[:booking_id])
    @guest = Guest.find(params[:id])
  end

  # POST /guests
  # POST /guests.json
  def create
    @guest = Guest.new(params[:guest])

    respond_to do |format|
      if @guest.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Number of guests is now ' + @guest.number.to_s }
        format.json { render :json => @guest, :event => :created, :location => @guest }
      else
        format.html { render :action => "new" }
        format.json { render :json => @guest.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /guests/1
  # PUT /guests/1.json
  def update
    @guest = Guest.find(params[:id])

    respond_to do |format|
      if @guest.update_attributes(params[:guest])
        format.html { redirect_to @guest, :notice => 'Guest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @guest.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy

    respond_to do |format|
      format.html { redirect_to guests_url }
      format.json { head :no_content }
    end
  end
end
