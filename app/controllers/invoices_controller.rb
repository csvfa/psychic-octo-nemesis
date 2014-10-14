class InvoicesController < ApplicationController
  # GET /invoices
  # GET /invoices.json
  def index 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @booking = Booking.find(params[:booking_id])
    if @booking.invoice.present?
      redirect_to edit_invoice_path(@booking.invoice.id)
    else
      @invoice = Invoice.new
      @invoice.version_number = 1

      @invoice.booking = @booking
      @invoice.set_default_dates
      
      @invoice.calculate_deposit_amount

      respond_to do |format|
        if @invoice.save
          @invoice.create_first_line_item
          format.html { redirect_to edit_invoice_path(@invoice.id), notice: 'Invoice was successfully created.' }
          format.json { render json: @invoice, status: :created, location: @invoice }
        else
          format.html { render action: "new" }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
    @booking = @invoice.booking
    
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        create_first_line_item unless @invoice.booking.pricing_structure.rate_per_person.nil?
        format.html { redirect_to invoice_path(@invoice.id), notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])
    
    if session[:return_to].nil?
      return_path = root_path
    else
      return_path = session.delete(:return_to) + "#booking" + @invoice.booking.id.to_s
    end
    
    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to return_path, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.json { head :no_content }
    end
  end
end