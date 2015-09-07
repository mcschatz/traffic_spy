class Payload
  attr_reader :request,
              :status,
              :body

  def initialize(identifier, payload = false)
    @request  = Request.new
    @user     = User.find_by_identifier(identifier)
    valid?(identifier, payload)
  end

  def valid?(identifier, payload)
    if !payload
      @body   = "Missing the payload\n"
      @status = 400
    else
      generate_response(payload)
    end
  end

  def sha(payload)
    Digest::SHA1.hexdigest(payload)
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

  def generate_response(raw_payload)
    payload  = JSON.parse(raw_payload)

    request.user          = @user if @user
    request.sha           = sha(raw_payload)
    request.requested_at  = requested_at(payload)
    request.response_time = response_time(payload)

    if save_payload(payload)
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

  def save_payload(payload)
    if request.save
      url(payload)
      browser(payload)
      operating_system(payload)
      referral(payload)
      type(payload)
      event(payload)
      browser(payload)
      resolution(payload)
      true
    else
      false
    end
  end

end
