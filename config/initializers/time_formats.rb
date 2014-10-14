Time::DATE_FORMATS[:standard] = "%l:%M%P %a %e-%b-%y"
Time::DATE_FORMATS[:date_only] = "%a %e-%b-%y"
Time::DATE_FORMATS[:full_date_only] = lambda { |time| time.strftime("%A, #{time.day.ordinalize} %B %Y") }
Time::DATE_FORMATS[:time_only] = "%l:%M%P"
Date::DATE_FORMATS[:standard] = "%a %e-%b-%y"
Date::DATE_FORMATS[:full] = lambda { |time| time.strftime("%A, #{time.day.ordinalize} %B %Y") }