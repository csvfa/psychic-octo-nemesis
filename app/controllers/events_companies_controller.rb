class EventsCompaniesController < ApplicationController
  # GET /events_companies
  # GET /events_companies.json
  def index
    @events_companies = EventsCompany.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events_companies }
    end
  end

  # GET /events_companies/1
  # GET /events_companies/1.json
  def show
    @events_company = EventsCompany.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @events_company }
    end
  end

  # GET /events_companies/new
  # GET /events_companies/new.json
  def new
    @events_company = EventsCompany.new
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @events_company }
    end
  end

  # GET /events_companies/1/edit
  def edit
    @events_company = EventsCompany.find(params[:id])
  end

  # POST /events_companies
  # POST /events_companies.json
  def create
    @events_company = EventsCompany.new(params[:events_company])

    respond_to do |format|
      if @events_company.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Events company was successfully created.' }
        format.json { render :json => @events_company, :event => :created, :location => @events_company }
      else
        format.html { render :action => "new" }
        format.json { render :json => @events_company.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /events_companies/1
  # PUT /events_companies/1.json
  def update
    @events_company = EventsCompany.find(params[:id])

    respond_to do |format|
      if @events_company.update_attributes(params[:events_company])
        format.html { redirect_to @events_company, :notice => 'Events company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @events_company.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /events_companies/1
  # DELETE /events_companies/1.json
  def destroy
    @events_company = EventsCompany.find(params[:id])
    @events_company.destroy

    respond_to do |format|
      format.html { redirect_to events_companies_url }
      format.json { head :no_content }
    end
  end
end
