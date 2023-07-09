require 'uri'
require 'net/http'
require 'json'

class EasyBrokerApiServices
  BASE_API_ENDPOINT = "https://api.stagingeb.com/v1"

  def initialize(auth_key)
    @auth_key = auth_key
  end

  def contact_requests(params)
    response = get_request(:contact_requests, params)

    response
  end

  def get_request(endpoint, params)
    url = build_url(endpoint, params)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url, headers)

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      parse_body(response)
    else
      msg = "Failed to make request to #{url} got #{response.code} status"
      error_response = parse_body(response).try(:[], "error")
      msg << " and error message: #{error_response}" if error_response

      raise msg
    end
  end

  def build_url(endpoint, params)
    resource = "#{BASE_API_ENDPOINT}/#{endpoint}"
    url = URI(resource)
    url.query = URI.encode_www_form(params) if params

    url
  end

  def parse_body(response)
    begin
      JSON.parse(response.read_body.force_encoding("UTF-8"))
    rescue => e
      raise "Failed to parse response body got: #{e.message}"
    end
  end

  def headers
    {
      "accept" => 'application/json',
      "X-Authorization" => @auth_key
    }
  end
end
