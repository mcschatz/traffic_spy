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
        sha              = Digest::SHA1.hexdigest(params[:payload])
        payload          = JSON.parse(params[:payload])
        address          = payload["url"]
        browser          = UserAgent.parse(payload["userAgent"]).browser
        operating_system = UserAgent.parse(payload["userAgent"]).platform
        user             = User.find_by_identifier(identifier)
        root_url         = User.find_by_identifier(identifier).root_url

        request = Request.create({:sha => sha})
        if request.errors.full_messages != []
          body "This request has already been recorded."
          status 403
        elsif !address.include?(root_url)
          body "This application is not registered to this user."
          status 403
        else
          user.requests << request
          url = Url.create({:address => address})
          browser = Browser.create({:name => browser})
          operating_system = OperatingSystem.create({:name => operating_system})
          url.requests << request
          browser.requests << request
          operating_system.requests << request
        end
      end
    end

    get '/sources/:identifier' do |identifier|
      user = User.find_by_identifier(identifier)

      addresses = user.urls.map { |url| url.address }
      group = addresses.group_by { |address| addresses.count(address) }
      @urls = group.sort_by { |count, address| count }.reverse

      browsers = user.browsers.map { |browser| browser.name }
      group = browsers.group_by { |name| browsers.count(name) }
      @browsers = group.sort_by { |count, name| count }.reverse

      erb :dashboard
    end

    not_found do
      erb :error
    end
    #
    # def breakdown(user_objects, desired_data)
    #   stuff = user_objects.map { |user_object| user_object.desired_data }
    #   group = addresses.group_by { |address| addresses.count(address) }
    #   @urls = group.sort_by { |count, address| count }.reverse
    # end
  end
end
