module Tr3llo
  class RemoteServer
    attr_reader :endpoint_uri

    EXPECTED_CODES = ["200"].freeze

    def initialize(endpoint_url)
      @endpoint_uri = URI(endpoint_url)
    end

    def get(req_path, req_headers, expected_codes = EXPECTED_CODES)
      req_uri = endpoint_uri.merge(req_path)
      req_headers = {"accept" => "application/json"}.merge(req_headers)

      dispatch(Net::HTTP::Get.new(req_uri, req_headers), expected_codes)
    end

    def post(req_path, req_headers, payload, expected_codes = EXPECTED_CODES)
      req_uri = endpoint_uri.merge(req_path)

      req_headers = {
        "accept" => "application/json",
        "content-type" => "application/json"
      }.merge(req_headers)

      request = Net::HTTP::Post.new(req_uri, req_headers)
      request.body = JSON.dump(payload)

      dispatch(request, expected_codes)
    end

    def put(req_path, req_headers, payload, expected_codes = EXPECTED_CODES)
      req_uri = endpoint_uri.merge(req_path)

      req_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }.merge(req_headers)

      request = Net::HTTP::Put.new(req_uri, req_headers)
      request.body = JSON.dump(payload)

      dispatch(request, expected_codes)
    end

    def delete(path, params)
      request_uri = URI::HTTPS.build(path: BASE_PATH + path)

      req_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      request = Net::HTTP::Delete.new(request_uri.request_uri, req_headers)
      request.body = JSON.dump(params)
      response = dispatch(request)

      case response
      when Net::HTTPOK then response.body
      else raise(RequestError.new(response.body))
      end
    end

    private

    def query_string(params)
      URI.encode_www_form(params)
    end

    def dispatch(request, expected_status_codes)
      response =
        Net::HTTP.start(endpoint_uri.host, endpoint_uri.port) do |http|
          http.request(request)
        end

      if expected_status_codes.include?(response.code)
        JSON.parse(response.body)
      else
        raise "YOLO"
      end
    end
  end
end
