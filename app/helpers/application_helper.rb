module ApplicationHelper
	def get_15_minute_time_increments(date)
		time_start = date.change(:hour => 9, :minute => 0, :second => 0)
		time_end = date.change(:hour => 20, :minute => 0, :second => 0)
		[time_start].tap { |array| array << array.last + 15.minutes while array.last < time_end }
	end
end
