class User < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true
  has_many  :requests
  has_many  :urls, :through => :requests
  has_many  :browsers, :through => :requests
  has_many  :operating_systems, :through => :requests
  has_many  :resolutions, :through => :requests
  has_many  :events, :through => :requests

  def dashboard(user)
    params                                    = {}
    params[:url_info]                         = breakdown(user.urls, :address)
    params[:browser_info]                     = breakdown(user.browsers, :name)
    params[:os_info]                          = breakdown(user.operating_systems, :name)
    params[:resolution_info]                  = breakdown(user.resolutions, :description)
    params[:sorted_avg_response_times_by_url] = sorted_avg_response_times_by_url(user)
    params
  end

  def sorted_avg_response_times_by_url(user)
    urls = user.urls.uniq
    response_times = urls.map do |url|
      {:address => url.address, :ave_response_time => url.requests.average(:response_time).to_f.round(2)}
    end
    response_times.sort_by{|data| data[:ave_response_time]}.reverse
  end

  def breakdown(collection, column)
    collection.group(column).order('count_id DESC').count(:id).map do |column, count|
      percent = (count.to_f/collection.count * 100).round(2)
      {description: column, count: count, percent: percent}
    end
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

  def response(user)
    {:body => body(user), :status => status(user)}
  end

  def body(user)
    if user.save
     {:identifier => user.identifier}.to_json
    else
      user.errors.full_messages
    end
  end

  def status(user)
    if user.save
      200
    elsif user.identifier == nil || user.root_url == nil
      400
    else
      403
    end
  end
end
