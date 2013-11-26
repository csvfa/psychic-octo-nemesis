class OpeningTimesController < ApplicationController
  # GET /opening_times
  # GET /opening_times.json
  def index
    @opening_times = OpeningTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @opening_times }
    end
  end

  # GET /opening_times/1
  # GET /opening_times/1.json
  def show
    @opening_time = OpeningTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @opening_time }
    end
  end

  # GET /opening_times/new
  # GET /opening_times/new.json
  def new
    @opening_time = OpeningTime.new
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @opening_time }
    end
  end

  # GET /opening_times/1/edit
  def edit
    @opening_time = OpeningTime.find(params[:id])
  end

  # POST /opening_times
  # POST /opening_times.json
  def create
    @opening_time = OpeningTime.new(params[:opening_time])

    respond_to do |format|
      if @opening_time.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Opening time was successfully created.' }
        format.json { render :json => @opening_time, :event => :created, :location => @opening_time }
      else
        format.html { render :action => "new" }
        format.json { render :json => @opening_time.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /opening_times/1
  # PUT /opening_times/1.json
  def update
    @opening_time = OpeningTime.find(params[:id])

    respond_to do |format|
      if @opening_time.update_attributes(params[:opening_time])
        format.html { redirect_to @opening_time, :notice => 'Opening time was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @opening_time.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /opening_times/1
  # DELETE /opening_times/1.json
  def destroy
    @opening_time = OpeningTime.find(params[:id])
    @opening_time.destroy

    respond_to do |format|
      format.html { redirect_to opening_times_url }
      format.json { head :no_content }
    end
  end
end
