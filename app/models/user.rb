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
    params[:url_info]                         = url_info(user)
    params[:browser_info]                     = browser_info(user)
    params[:os_info]                          = os_info(user)
    params[:resolution_info]                  = resolution_info(user)
    params[:sorted_avg_response_times_by_url] = sorted_avg_response_times_by_url(user)
    params
  end

  def url_info(user)
    breakdown(user.urls, :address)
  end

  def browser_info(user)
    breakdown(user.browsers, :name)
  end

  def os_info(user)
    breakdown(user.operating_systems, :name)
  end

  def resolution_info(user)
    breakdown(user.resolutions, :description)
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

  def find_events(user, event_name)
    event = user.events.find_by_name(event_name)
    if event
      events = event.requests.group("date_part('hour', requested_at)").count
      (0..23).each do |hour|
        events[hour.to_f] ||= 0
      end
      events
    else
      false
    end
  end

  def response(user)
    params          = {}
    params[:body]   = body(user)
    params[:status] = status(user)
    params
  end

  def body(user)
    if user.save
     id_hash = {identifier: user.identifier}
      "#{id_hash.to_json}"
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
