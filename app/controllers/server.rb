module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    get '/sources' do
      erb :sources
    end

    post '/sources' do
      user = User.new(params[:user])
      if user.save
        id_hash = {identifier: user.identifier}
        body "#{id_hash.to_json}"
      else
        body user.errors.full_messages
        status 400
      end

    end

    not_found do
      erb :error
    end
  end
end
