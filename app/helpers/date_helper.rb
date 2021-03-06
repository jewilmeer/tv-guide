module DateHelper
  def pretty_date timestamp, options={}
    time_tag timestamp do
      date = Date.parse(timestamp.to_s)
      case date_diff(date)
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
        if date_needs_year? date
          l date, :format => :with_day
        else
          l date, :format => :short_with_weekday
        end
      end
    end
  end

  private

  def date_diff date
    date - Date.today
  end

  def date_needs_year? date
    Date.today.year != date.year
  end
end