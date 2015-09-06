class Manipulate

  def self.breakdown(collection, method)
    total = collection.count
    descriptions = collection.map {|table_object| table_object.send(method)}
    group = descriptions.group_by {|description| descriptions.count(description)}
    sorted_group = group.sort_by {|count, description| count}.reverse

    # returns a sorted array of hashes with {:description, :count, :percent}
    sorted_group.map do |count, description|
      percent = (count.to_f/total * 100).round(2)
      {description: description.first, count: count, percent: percent}
    end
  end

  def self.sorted_avg_response_times_by_url(urls)
    response_times = urls.map do |url|
      {:address => url.address,
       :ave_response_time => url.requests.average(:response_time).to_f.round(2)}
    end
    response_times.sort_by{|data| data[:ave_response_time]}.reverse
  end

end
