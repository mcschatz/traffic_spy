module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      @users = User.all
      erb :index
    end

    get '/sources' do
      erb :sources
    end

    post '/sources' do
      user = User.new({:root_url => params[:rootUrl], :identifier => params[:identifier]})
      if user.save
        id_hash = {identifier: user.identifier}
        body "#{id_hash.to_json}"
      elsif user.identifier == nil || user.root_url == nil
        body user.errors.full_messages
        status 400
      else
        body user.errors.full_messages
        status 403
      end
    end

    post '/sources/:identifier/data' do |identifier|
      if !params[:payload]
        body "Missing the payload\n"
        status 400
      else
        sha              = Digest::SHA1.hexdigest(params[:payload])
        payload = JSON.parse(params[:payload])
        response_time    = payload["respondedIn"].to_i

        user             = User.find_by_identifier(identifier)
        root_url         = User.find_by_identifier(identifier).root_url
        address = payload["url"]

        request = Request.create({:sha => sha,
                                  :response_time => response_time})
        if request.errors.full_messages != []
          body "This request has already been recorded.\n"
          status 403
        elsif !address.include?(root_url)
          body "This application is not registered to this user.\n"
          status 403
        else
          user.requests << request

          url = Url.find_or_create_by({:address => address})
          url.requests << request

          browser = UserAgent.parse(payload["userAgent"]).browser
          browser = Browser.find_or_create_by({:name => browser})
          browser.requests << request

          operating_system = UserAgent.parse(payload["userAgent"]).platform
          operating_system = OperatingSystem.find_or_create_by({:name => operating_system})
          operating_system.requests << request

          resolution = "#{payload['resolutionWidth']} x #{payload['resolutionHeight']}"
          resolution = Resolution.find_or_create_by({:description => resolution})
          resolution.requests << request

          body "Success!\n"
        end
      end
    end

    def breakdown(collection, method)
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

    def sorted_ave_response_times_by_url(urls)
    	response_times = urls.map do |url|
        {:address => url.address,
         :ave_response_time => url.requests.average(:response_time).to_f.round(2)}
      end
      response_times.sort_by{|data| data[:ave_response_time]}.reverse
    end

    get '/sources/:identifier' do |identifier|
    ### if identifier doesn't exist, display useful message on site, else do this...
      @user = User.find_by_identifier(identifier)

      @urls_info = breakdown(@user.urls, :address)
      @browsers_info = breakdown(@user.browsers, :name)
      @os_info = breakdown(@user.operating_systems, :name)
      @resolution_info = breakdown(@user.resolutions, :description)
      @sorted_ave_response_times = sorted_ave_response_times_by_url(@user.urls.uniq)

      erb :dashboard
    end

    get '/sources/:identifier/urls/*' do |identifier, path|
      @path = path
      erb :url_stats
    end

    not_found do
      erb :error
    end
  end
end
