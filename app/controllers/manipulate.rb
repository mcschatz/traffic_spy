class Manipulate

  def self.breakdown(collection, column)
    collection.group(column).order('count_id DESC').count(:id).map do |column, count|
      percent = (count.to_f/collection.count * 100).round(2)
      {description: column, count: count, percent: percent}
    end
  end

  def self.sorted_avg_response_times_by_url(urls)
    response_times = urls.map do |url|
      {:address => url.address, :ave_response_time => url.requests.average(:response_time).to_f.round(2)}
    end
    response_times.sort_by{|data| data[:ave_response_time]}.reverse
  end

end
