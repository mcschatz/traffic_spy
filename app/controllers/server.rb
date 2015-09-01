module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    get '/sources' do
      erb :sources
    end

    not_found do
      erb :error
    end
  end
end
