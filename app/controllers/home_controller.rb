class HomeController < ApplicationController
  def index
	# Bookings on or after today
	@dates = Booking.datesOfCurrentBookings
		
	# order by city, venue, timeslot, time
	
	# attempt 1 here doesn't work because a booking may not have a studio
	#	@finalSorted = @currentBookings.sort_by
	#		{|x|
	#			[x.studio.venue.city.name,
	#			x.studio.venue.name,
	#			x.timeslot]
	#		}
  end
end
