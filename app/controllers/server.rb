require_relative 'manipulate'

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

    get '/sources/:identifier' do |identifier|
      @user = User.find_by_identifier(identifier)

      if @user
        @urls_info = Manipulate.breakdown(@user.urls, :address)
        @browsers_info = Manipulate.breakdown(@user.browsers, :name)
        @os_info = Manipulate.breakdown(@user.operating_systems, :name)
        @resolution_info = Manipulate.breakdown(@user.resolutions, :description)
        @sorted_avg_response_times = Manipulate.sorted_avg_response_times_by_url(@user.urls.uniq)

        erb :dashboard
      else
        @message = "The requested user, #{identifier}, is not registered."
        erb :error
      end
    end

    get '/sources/:identifier/urls/*' do |identifier, path|
      address = User.find_by_identifier(identifier).root_url + "/#{path}"
      @url = Url.find_by_address(address)
      if @url
        @identifier = identifier
        @path = path

        erb :url_stats
      else
        @message = "The URL, #{address}, has had zero requests."
        erb :error
      end
    end

    get '/sources/:identifier/events' do |identifier|
      erb :events
    end

    not_found do
      erb :error
    end
  end
end
