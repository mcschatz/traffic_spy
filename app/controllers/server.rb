module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
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
      payload = JSON.parse(params[:payload])
      url = payload["url"]
      requested_at = payload["requestedAt"]
      responded_in = payload["respondedIn"].to_i
      referred_by = payload["referredBy"]
      request_type = payload["requestType"]
      parameters = payload["parameters"]
      event_name = payload["eventName"]
      os = UserAgent.parse(payload["userAgent"]).platform
      browser = UserAgent.parse(payload["userAgent"]).browser
      resolution_width = payload["resolutionWidth"]
      resolution_height = payload["resolutionHeight"]
      ip = payload["ip"]
      request = Request.new({ :url => url,
                      :requested_at => requested_at,
                      :responded_in => responded_in,
                      :referred_by => referred_by,
                      :request_type => request_type,
                      :parameters => parameters,
                      :event_name => event_name,
                      :os => os,
                      :browser => browser,
                      :resolution_width => resolution_width,
                      :resolution_height => resolution_height,
                      :ip => ip })
      require 'pry'; binding.pry
      request.save
    end

    not_found do
      erb :error
    end
  end
end
