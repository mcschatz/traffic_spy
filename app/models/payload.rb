class Payload
  attr_reader :request

  def initialize
    @request  = Request.new
  end

  def parse(params, identifier)
    payload  = JSON.parse(params)

    request.sha           = sha(params)
    request.requested_at  = requested_at(payload)
    request.response_time = response_time(payload)

    user(identifier)
    url(payload)
    browser(payload)
    operating_system(payload)
    referral(payload)
    type(payload)
    event(payload)
    browser(payload)
    resolution(payload)


    @request
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

  def user(identifier)
   user = User.find_by_identifier(identifier)
   user.requests << request
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
end