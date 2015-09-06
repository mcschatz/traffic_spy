class Payload
  attr_reader :request,
              :status,
              :body

  def initialize(identifier, params = false)
    @request  = Request.new
    @user     = User.find_by_identifier(identifier)
    valid?(identifier, params)
  end

  def valid?(identifier, params)
    if !params
      @body   = "Missing the payload\n"
      @status = 400
    else
      parse(params, identifier)
    end
  end

  def parse(params, identifier)
    payload  = JSON.parse(params)

    request.user          = @user if @user
    request.sha           = sha(params)
    request.requested_at  = requested_at(payload)
    request.response_time = response_time(payload)

    url(payload)
    browser(payload)
    operating_system(payload)
    referral(payload)
    type(payload)
    event(payload)
    browser(payload)
    resolution(payload)

    response(request)
  end

  def sha(params)
    Digest::SHA1.hexdigest(params)
  end

  def requested_at(payload)
    payload["requestedAt"]
  end

  def response_time(payload)
    payload["respondedIn"].to_i
  end

  def url(payload)
    url = Url.find_or_create_by({:address => payload["url"]})
    url.requests << request
  end

  def browser(payload)
    browser = UserAgent.parse(payload["userAgent"]).browser
    browser = Browser.find_or_create_by({:name => browser})
    browser.requests << request
  end

  def operating_system(payload)
    operating_system = UserAgent.parse(payload["userAgent"]).platform
    operating_system = OperatingSystem.find_or_create_by({:name => operating_system})
    operating_system.requests << request
  end

  def resolution(payload)
    resolution = "#{payload['resolutionWidth']} x #{payload['resolutionHeight']}"
    resolution = Resolution.find_or_create_by({:description => resolution})
    resolution.requests << request
  end

  def type(payload)
    type = Type.find_or_create_by({:name => payload["requestType"]})
    type.requests << request
  end

  def referral(payload)
    referral = Referral.find_or_create_by(:address => payload["referredBy"])
    referral.requests << request
  end

  def event(payload)
    event = Event.find_or_create_by(:name => payload["eventName"])
    event.requests << request
  end

  def response(request)
    if request.save
      @body   = "Success!\n"
      @status = 200
    elsif !@user
      @body   = "This application is not registered to this user.\n"
      @status = 403
    else
      @body   = "This request already exists.\n"
      @status = 403
    end
  end
end