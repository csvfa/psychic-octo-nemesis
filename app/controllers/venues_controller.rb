class VenuesController < ApplicationController
  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @venues }
    end
  end

  # GET /venues/1
  # GET /venues/1.json
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @venue }
    end
  end

  # GET /venues/new
  # GET /venues/new.json
  def new
        @venue = Venue.new
        @cities = City.all
        @studio = Studio.new(name: "Default")
      @venue.studios << @studio
      
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
    @cities = City.all
	  
	session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])
    @cities = City.all
    
      # if studio is the default one, assign name Default

    respond_to do |format| 
      if @venue.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Venue was successfully created.' }
        format.json { render :json => @venue, :event => :created, :location => @venue }
      else
        format.html { render :action => "new" }
        format.json { render :json => @venue.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to session.delete(:return_to), :notice => 'Venue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @venue.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to venues_url }
      format.json { head :no_content }
    end
  end
end
