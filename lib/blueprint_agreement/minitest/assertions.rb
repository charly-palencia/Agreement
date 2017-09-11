module Minitest
  module Assertions
    def assert_shall_agree_upon contract_name, response
      BlueprintAgreement::Utils::Matcher.new(self).match(contract_name, response)
    end
  end
end
