module DateHelper
  def pretty_date timestamp, options={}
    time_tag timestamp do
      time = Time.parse(timestamp.to_s)
      case date_diff(time)
      when 0
        'Today'
      when -1
        'Yesterday'
      when 1
        'Tomorrow'
      when 2..7
        "Next #{ l(time, :format => :weekday)}"
      when -7..-2
        "Last #{ l(time, :format => :weekday)}"
      else
        date = time.to_date
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
    date.to_date - Date.today
  end

  def date_needs_year? date
    Date.today.year != date.year
  end
end