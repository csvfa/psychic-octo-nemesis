class ReceivedLineItemsController < ApplicationController
  # GET /received_line_items
  # GET /received_line_items.json
  def index
    @received_line_items = ReceivedLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @received_line_items }
    end
  end

  # GET /received_line_items/1
  # GET /received_line_items/1.json
  def show
    @received_line_item = ReceivedLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @received_line_item }
    end
  end

  # GET /received_line_items/new
  # GET /received_line_items/new.json
  def new
    @received_line_item = ReceivedLineItem.new
    @invoice = Invoice.find(params[:invoice_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @received_line_item }
    end
  end

  # GET /received_line_items/1/edit
  def edit
    @received_line_item = ReceivedLineItem.find(params[:id])
    @invoice = @received_line_item.invoice
  end

  # POST /received_line_items
  # POST /received_line_items.json
  def create
    @received_line_item = ReceivedLineItem.new(params[:received_line_item])

    respond_to do |format|
      if @received_line_item.save
        format.html { redirect_to @received_line_item.invoice, notice: 'Received line item was successfully created.' }
        format.json { render json: @received_line_item, status: :created, location: @received_line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @received_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /received_line_items/1
  # PUT /received_line_items/1.json
  def update
    @received_line_item = ReceivedLineItem.find(params[:id])

    respond_to do |format|
      if @received_line_item.update_attributes(params[:received_line_item])
        format.html { redirect_to @received_line_item.invoice, notice: 'Received line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @received_line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /received_line_items/1
  # DELETE /received_line_items/1.json
  def destroy
    @received_line_item = ReceivedLineItem.find(params[:id])
    @received_line_item.destroy

    respond_to do |format|
      format.html { redirect_to received_line_items_url }
      format.json { head :no_content }
    end
  end
end
