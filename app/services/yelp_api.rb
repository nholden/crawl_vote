class YelpApi

  def initialize(parameters)
    @parameters = parameters
  end

  private

  def response
    @response ||= Excon.get(
      "https://api.yelp.com/v3#{api_path}",
      headers: { 'Authorization' => "Bearer #{ENV.fetch('YELP_API_KEY')}" },
      query: @parameters
    )
  end

  def parsed_response_body
    if response.status == 200
      JSON.parse(response.body)
    else
      raise "Yelp API returned a #{response.status} status: #{response.body}"
    end
  end

  def api_path
    raise 'api_path must be defined by subclass'
  end

end
