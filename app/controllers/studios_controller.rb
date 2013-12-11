class StudiosController < ApplicationController
    
  # GET /studios
  # GET /studios.json
    def index
        #studios, from north to south, grouped by venue.
        @studios = Studio.joins(venue: :city).order("latitude DESC", "venues.name")

        respond_to do |format|
            format.html # index.html.erb
            format.json { render :json => @studios }
        end
    end

  # GET /studios/1
  # GET /studios/1.json
  def show
    @studio = Studio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @studio }
    end
  end

    # GET /studios/new
    # GET /studios/new.json
    def new
        @studio = Studio.new
		@venues = Venue.all
      
        logger.debug "session[:return_to] is " + session[:return_to].to_s
        logger.debug "request.referer is " + request.referer
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @studio }
    end
  end

    # GET /studios/1/edit
    def edit
        @studio = Studio.find(params[:id])
		@venues = Venue.all
    end

    # POST /studios
    # POST /studios.json
    def create
        @studio = Studio.new(params[:studio])

    respond_to do |format|
      if @studio.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Studio was successfully created.' }
        format.json { render :json => @studio, :event => :created, :location => @studio }
      else
        format.html { render :action => "new" }
        format.json { render :json => @studio.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /studios/1
  # PUT /studios/1.json
  def update
    @studio = Studio.find(params[:id])

    respond_to do |format|
      if @studio.update_attributes(params[:studio])
        format.html { redirect_to studios_path, :notice => 'Studio was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @studio.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /studios/1
  # DELETE /studios/1.json
  def destroy
    @studio = Studio.find(params[:id])
    @studio.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.json { head :no_content }
    end
  end
	
	# Called by Javascript when the City drop down is changed so that the Studios select only has
	# array of arrays [id, name] studios in the selected city
	def in_city_id
		@studioNames = Array.new
		
		Studio.in_city(City.find(params[:id])).each do |studio|
			@studioNames << [studio.id, studio.to_s]
		end
		
		respond_to do |format|
			format.json  { render :json => @studioNames }      
		end
	end
end
