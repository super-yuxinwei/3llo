require "net/http"
require "openssl"
require "3llo/http/request_error"

module Tr3llo
  module HTTP
    module Client
      extend self

      REMOTE_HOST = "api.trello.com".freeze()
      REMOTE_PORT = 443
      BASE_PATH = "/1".freeze

      def get(path, params = {})
        request_uri = URI::HTTPS.build(path: BASE_PATH + path, query: query_string(params))
        req_headers = {"accept" => "application/json"}
        response = dispatch(Net::HTTP::Get.new(request_uri.request_uri, req_headers))

        case response
        when Net::HTTPOK then response.body
        else raise(RequestError.new(response.body))
        end
      end

      def post(path, params)
        request_uri = URI::HTTPS.build(path: BASE_PATH + path)

        req_headers = {
          "accept" => "application/json",
          "content-type" => "application/json"
        }

        request = Net::HTTP::Post.new(request_uri.request_uri, req_headers)
        request.body = JSON.dump(params)
        response = dispatch(request)

        case response
        when Net::HTTPOK then response.body
        else raise(RequestError.new(response.body))
        end
      end

      def put(path, params)
        request_uri = URI::HTTPS.build(path: BASE_PATH + path)

        req_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }

        request = Net::HTTP::Put.new(request_uri.request_uri, req_headers)
        request.body = JSON.dump(params)
        response = dispatch(request)

        case response
        when Net::HTTPOK then response.body
        else raise(RequestError.new(response.body))
        end
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

      def dispatch(request)
        Net::HTTP.start(REMOTE_HOST, REMOTE_PORT, use_ssl: true) do |http|
          http.request(request)
        end
      end
    end
  end
end
