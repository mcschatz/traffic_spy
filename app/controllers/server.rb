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
      request = Payload.new(identifier, params[:payload])
      status request.status
      body   request.body
    end

    get '/sources/:identifier' do |identifier|
      @user = User.find_by_identifier(identifier)

      if @user
        @user_info = User.new.dashboard(@user)
        erb :dashboard
      else
        @message = "The requested user, #{identifier}, is not registered."
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
      @event = user.events.find_by_name(event_name)

      if @event
        event_requests = @event.requests
        @requested = event_requests.group("date_part('hour', requested_at)").count
        (0..23).each do |hour|
          @requested[hour.to_f] ||= 0
        end
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
