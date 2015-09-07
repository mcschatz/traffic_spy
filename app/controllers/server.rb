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
      user   = User.new({:root_url => params[:rootUrl],
                         :identifier => params[:identifier]})
      user   = user.response(user)
      status user[:status]
      body   user[:body]
    end

    post '/sources/:identifier/data' do |identifier|
      payload = Payload.new(identifier, params[:payload])
      status payload.status
      body   payload.body
    end

    get '/sources/:identifier' do |identifier|
      @user = User.find_by_identifier(identifier)

      if @user
        @user_info = User.new.dashboard(@user)
        erb :dashboard
      else
        @message = "The requested user, #{identifier.capitalize}, is not registered."
        erb :error
      end
    end

    get '/sources/:identifier/urls/:path' do |identifier, path|
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
      @user = User.find_by_identifier(identifier)
      @events = @user.events

      if @events != []
        erb :events
      else
        @message = "There are no events for this user."
        erb :error
      end
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      user = User.find_by_identifier(identifier)
      @event = user.event_count_by_hour(user, event_name)

      if @event.size > 0
        erb :event_details
      else
        @message = "There are no requests from this event."
        @link = {:address => "/sources/#{identifier}/events", :text => 'Back to Events Index'}
        erb :error
      end
    end

    not_found do
      erb :error
    end
  end
end
