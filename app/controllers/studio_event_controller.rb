class StudioEventController < ApplicationController
  # GET /events/new
  # GET /events/new.json
  def new
    @booking = Booking.find(params["booking_id"])
    @event = StudioEvent.new(:booking => @booking)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end
end
