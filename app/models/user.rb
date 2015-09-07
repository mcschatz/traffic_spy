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
    params[:browser_info]                     = browser_info(user.browsers)
    params[:os_info]                          = os_info(user.operating_systems)
    params[:resolution_info]                  = resolution_info(user.resolutions)
    params[:sorted_avg_response_times_by_url] = sorted_avg_response_times_by_url(user.urls.uniq)
    params
  end

  def url_info(user)
    breakdown(user.urls, :address)
  end

  def browser_info(user)
    breakdown(browsers, :name)
  end

  def os_info(os)
    breakdown(os, :name)
  end

  def resolution_info(resolutions)
    breakdown(resolutions, :description)
  end

  def sorted_avg_response_times_by_url(urls)
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
end
