class ServiceProvidedLineItemsController < ApplicationController
  # GET /service_provided_line_items
  # GET /service_provided_line_items.json
  def index
    @service_provided_line_items = ServiceProvidedLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @service_provided_line_items }
    end
  end

  # GET /service_provided_line_items/1
  # GET /service_provided_line_items/1.json
  def show
    @service_provided_line_item = ServiceProvidedLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service_provided_line_item }
    end
  end

  # GET /service_provided_line_items/new
  # GET /service_provided_line_items/new.json
  def new
    @service_provided_line_item = ServiceProvidedLineItem.new
    @invoice = Invoice.find(params[:invoice_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service_provided_line_item }
    end
  end

  # GET /service_provided_line_items/1/edit
  def edit
    @service_provided_line_item = ServiceProvidedLineItem.find(params[:id])
    @invoice = @service_provided_line_item.invoice
  end

  # POST /service_provided_line_items
  # POST /service_provided_line_items.json
  def create
    @service_provided_line_item = ServiceProvidedLineItem.new(params[:service_provided_line_item])
    @invoice = @service_provided_line_item.invoice

    respond_to do |format|
      if @service_provided_line_item.save
        format.html { redirect_to edit_invoice_path(@service_provided_line_item.invoice), notice: 'Service provided line item was successfully created.' }
        format.json { render json: @service_provided_line_item, status: :created, location: @service_provided_line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @service_provided_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /service_provided_line_items/1
  # PUT /service_provided_line_items/1.json
  def update
    @service_provided_line_item = ServiceProvidedLineItem.find(params[:id])
    @invoice = @service_provided_line_item.invoice

    respond_to do |format|
      if @service_provided_line_item.update_attributes(params[:service_provided_line_item])
        format.html { redirect_to edit_invoice_path(@service_provided_line_item.invoice), notice: 'Service provided line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @service_provided_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_provided_line_items/1
  # DELETE /service_provided_line_items/1.json
  def destroy
    @service_provided_line_item = ServiceProvidedLineItem.find(params[:id])
    return_path = edit_invoice_path(@service_provided_line_item.invoice)
    @service_provided_line_item.destroy

    respond_to do |format|
      format.html { redirect_to return_path }
      format.json { head :no_content }
    end
  end
end
