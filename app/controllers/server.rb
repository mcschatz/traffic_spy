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
        body 'User registered'
      end
      erb :sources
    end

    not_found do
      erb :error
    end
  end
end
