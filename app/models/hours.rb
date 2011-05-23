class Hours < ActiveRecord::Base
  belongs_to :business
  validate :close_after_open, :on => :update 

  def weekday
    Date::DAYNAMES[day]
  end

  def open?
    open_hour? && !closed?
  end

  def to_s
    if open?
      "#{open_hour}:#{sprintf "%02d", open_minute} #{open_meridian} - #{close_hour}:#{sprintf "%02d", close_minute} #{close_meridian}"
    else
      "Closed"
    end
  end

  protected

    def close_after_open
      if open? && open_meridian == close_meridian && close_meridian == 'pm'
        unless closed? || open_hour < close_hour  || open_hour == 12
          errors.add(:base, "Hours are not in order")
        end
      end
    end
end
