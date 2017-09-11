require 'rspec/expectations'

RSpec::Matchers.define :shall_agree_upon do |contract_name|
  match do |response|
    BlueprintAgreement::Utils::Matcher.new(self).match(contract_name, response)
  end
end
