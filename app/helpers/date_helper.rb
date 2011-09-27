module DateHelper
  def pretty_date date
    date = date.to_date

    case date - Date.today
    when 0
      'Today'
    when -1
      'Yesterday'
    when 1
      'Tomorrow'
    when 2..7
      "Next #{ l(date, :format => :weekday)}"
    when -7..-2
      "Last #{ l(date, :format => :weekday)}"
    else
      l date, :format => :short_with_weekday
    end
  end
end