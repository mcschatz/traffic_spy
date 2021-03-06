class User < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true
  has_many  :requests
  has_many  :urls, :through => :requests
  has_many  :browsers, :through => :requests
  has_many  :operating_systems, :through => :requests
  has_many  :resolutions, :through => :requests
  has_many  :events, :through => :requests

  def response
    {:body => body, :status => status}
  end

  def stats
    user_info                                    = {}
    user_info[:url_info]                         = DataManipulator.column_summary(urls, :address)
    user_info[:browser_info]                     = DataManipulator.column_summary(browsers, :name)
    user_info[:os_info]                          = DataManipulator.column_summary(operating_systems, :name)
    user_info[:resolution_info]                  = DataManipulator.column_summary(resolutions, :description)
    user_info[:sorted_avg_response_times_by_url] = sorted_avg_response_times_by_url
    user_info
  end

  def event_count_by_hour(user, event_name)
    event = user.events.find_by_name(event_name)
    if event
      events = event.requests.group("date_part('hour', requested_at)").count
      (0..23).each do |hour|
        events[hour.to_f] ||= 0
      end
      events
    else
      {}
    end
  end

private

  def body
    if save
     {:identifier => identifier}.to_json
    else
      errors.full_messages
    end
  end

  def status
    if save
      200
    elsif identifier == nil || root_url == nil
      400
    else
      403
    end
  end

  def sorted_avg_response_times_by_url
    urls = self.urls.uniq
    response_times = urls.map do |url|
      {:address => url.address, :ave_response_time => url.requests.average(:response_time).to_f.round(2)}
    end
    response_times.sort_by{|data| data[:ave_response_time]}.reverse
  end
end
