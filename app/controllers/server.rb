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
      if !params[:payload]
        body "Missing the payload"
        status 400
      else
        sha       = Digest::SHA1.hexdigest(params[:payload])
        payload   = JSON.parse(params[:payload])
        address   = payload["url"]
        user      = User.find_by_identifier(identifier)
        root_url  = User.find_by_identifier(identifier).root_url

        request = Request.create({:sha => sha})
        if request.errors.full_messages != []
          body "This request has already been recorded."
          status 403
        elsif !address.include?(root_url)
          body "This application is not registered to this user."
          status 403
        else
          url = Url.create({:address => address})
          user.requests << request
          url.requests << request
        end
      end
    end






    not_found do
      erb :error
    end
  end
end
