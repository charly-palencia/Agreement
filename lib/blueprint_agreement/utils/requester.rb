require 'net/http'

module BlueprintAgreement
  module Utils
    class Requester
      REQUEST_OPTIONS = {
        'GET' => Net::HTTP::Get,
        'POST' =>  Net::HTTP::Post,
        'PUT' =>  Net::HTTP::Put,
        'DELETE' => Net::HTTP::Delete,
        'PATCH' => Net::HTTP::Patch,
        'TRACE' => Net::HTTP::Trace,
        'OPTIONS' => Net::HTTP::Options,
      }

      def initialize(request, server)
        @current_request = request
        @request_option = REQUEST_OPTIONS[request_method]
        raise BlueprintAgreement::MethodNotFound if @request_option.nil?

        @server = server
      end

      def perform
        begin
          Net::HTTP.start(request_path.host, request_path.port) do |http|
            request = @request_option.new request_path
            set_form_data(request)
            set_headers(request)

            request_logger.for({
              body: current_request.body,
              headers: current_request.headers,
              path: request_path,
              request_method: request_method
            })

            http.request(request).tap do |http_response|
              puts request_logger.print if ENV["AGREEMENT_LOUD"]
              raise EndpointNotFound.new(http_response) if invalid_response?(http_response)
            end
          end
        rescue Errno::ECONNREFUSED
          sleep 1
          perform
        rescue Errno::ECONNRESET
          sleep 1
          perform
        end
      end

      private

      def invalid_response?(response)
        response.code == invalid_criteria[:code] &&
          response.content_type == invalid_criteria[:content_type] &&
          response.body == invalid_criteria[:body]
      end

      def invalid_criteria
        ::BlueprintAgreement::DrakovService::INVALID_RESPONSE
      end

      def request_logger
        Utils::RequestLogger.instance
      end

      def set_headers(request)
        current_request.headers.each do |key, value|
          request[key.to_s] = value
        end
      end

      def set_form_data(request)
        if ['POST', 'PUT', 'PATCH'].include? request_method
          request.body = current_request.body
        end
      end

      def request_method
        @request_method ||= current_request.request_method
      end

      def request_path
        @request_path ||= URI.join(server.host, current_request.fullpath)
      end

      attr_reader :current_request, :server
    end
  end
end
