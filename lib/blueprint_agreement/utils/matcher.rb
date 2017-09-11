require 'minitest/assertions'

module BlueprintAgreement
  module Utils
    class Matcher
      include Minitest::Assertions

      attr_accessor :context, :assertions

      def initialize(context)
        @context = context
        @assertions = 0
      end

      def match(contract_name, response)
        result      = response.body
        api_service = BlueprintAgreement::DrakovService.new(BlueprintAgreement.configuration)
        server      = BlueprintAgreement::Server.new(
          api_service: api_service,
          config: BlueprintAgreement.configuration
        )

        begin
          server.start(contract_name)
          request = BlueprintAgreement::RequestBuilder.for(context)
          requester = BlueprintAgreement::Utils::Requester.new(request, server)
          expected  = requester.perform.body.to_s

          unless BlueprintAgreement.configuration.exclude_attributes.nil?
            filters = BlueprintAgreement.configuration.exclude_attributes
            result = BlueprintAgreement::ExcludeFilter.deep_exclude(
              BlueprintAgreement::Utils.to_json(result),
              filters)
            expected = BlueprintAgreement::ExcludeFilter.deep_exclude(
              BlueprintAgreement::Utils.to_json(expected),
              filters)
          end

          result = BlueprintAgreement::Utils.response_parser(result)
          expected = BlueprintAgreement::Utils.response_parser(expected)

          assert_equal expected, result
        end
      end

    end
  end
end
