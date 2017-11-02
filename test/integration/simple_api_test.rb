require 'test_helper'
require 'blueprint_agreement'

describe "Rails" do
  let(:body) { JSON.generate({cookie: 'have a cookie!' }) }
  let(:env) do
    {
      'HTTP_COOKIE' => 'cookie=have-a-cookie',
      'CONTENT_TYPE' => 'application/json'
    }
  end
  let(:request) { RailsMocks::Request.new(fullpath: endpoint, env: env) }
  let(:last_response) { RailsMocks::Response.new(body: body, request: request) }

  before do
    module Rails; end
    BlueprintAgreement.configuration.server_path = './test/fixtures'
  end
  after do
    Object.send(:remove_const, :Rails)
  end

  describe 'cookies' do
    let(:endpoint) { '/cookie' }
    it 'returns a valid request' do
      last_response.shall_agree_upon('hello_api.md')
    end
  end

  describe 'extra_headers' do
    before do
      BlueprintAgreement.configuration.request_headers = ['Cookie', 'Content-Type', 'Accept', 'Version']
    end

    after do
      BlueprintAgreement.configuration.request_headers = ["Content-Type", "Authorization", "Cookie"]
    end

    let(:env) do
      {
        'HTTP_COOKIE' => 'cookie=have-a-cookie',
        'CONTENT_TYPE' => 'application/json',
        'HTTP_ACCEPT' => 'application/json',
        'HTTP_VERSION' => 'v1'
      }
    end
    let(:endpoint) { '/extra_headers' }

    it 'returns a valid request' do
      last_response.shall_agree_upon('hello_api.md')
    end
  end
end

describe "Rack Test" do
  class RackTestSession
    def initialize(headers = { "Content-Type" => "application/json" })
      @headers = headers
    end
  end

  let(:body) { JSON.generate({name: 'Hello World' }) }
  let(:last_request) { RailsMocks::Request.new(fullpath: endpoint) }
  let(:last_response) { RailsMocks::Response.new(body: body, request: last_request) }
  let(:rack_test_session) { RackTestSession.new }

  before do
    module Rack; module Test; end; end
    BlueprintAgreement.configuration.server_path = './test/fixtures'
  end

  describe 'when blueprint agreement was included but never used' do
    it 'returns a valid api request' do
      expect(true).must_equal(true)
    end
  end

  describe 'with valid request' do
    let(:endpoint){ '/message' }
    let(:rack_test_session) { RackTestSession.new(
      {
        "Accept": "application/json"
      }
    )}
    it 'returns a valid api request' do
      last_response.shall_agree_upon('hello_api.md')
    end
  end

  describe "when reponse is an expected not found" do
    let(:endpoint){ '/message' }
    let(:body) { JSON.generate({error: 'Not found message' }) }

    let(:rack_test_session) { RackTestSession.new(
      {
        "Accept": "application.404/json"
      }
    )}
    it 'returns a valid api request' do
      last_response.shall_agree_upon('hello_api.md')
    end
  end

  describe 'with invalid request' do
    let(:endpoint){ '/not_valid' }
    it 'returns a Not Found Route error' do
      expect { last_response.shall_agree_upon('hello_api.md') }.must_raise(BlueprintAgreement::EndpointNotFound)
    end
  end

  describe 'with exclude_attributes' do
    let(:body) { "\n{}\n" }
    let(:endpoint){ '/message' }
    let(:rack_test_session) { RackTestSession.new(
      {
        "Accept": "application/json"
      }
    )}
    before do
      BlueprintAgreement.configuration.exclude_attributes = ['name']
    end

    it 'returns a Not Found Route error' do
     last_response.shall_agree_upon('hello_api.md')
    end
  end

  describe 'with exclude_attributes' do
    let(:endpoint){ '/message/1' }
    let(:last_request) { RailsMocks::Request.new(fullpath: endpoint, request_method: 'PATCH') }

    it 'validates PATCH method' do
      last_response.shall_agree_upon('hello_api.md')
    end
  end

  describe 'with blank results' do
    let(:body) { "" }
    let(:endpoint){ '/message/empty' }
    let(:last_request) { RailsMocks::Request.new(fullpath: endpoint, request_method: 'POST') }

    before do
      BlueprintAgreement.configuration.exclude_attributes = ['name']
    end

    it 'returns a Not Found Route error' do
     last_response.shall_agree_upon('hello_api.md')
    end
  end

  describe 'with multiple apib files' do
    let(:endpoint){ '/message/1' }
    let(:last_request) { RailsMocks::Request.new(fullpath: endpoint, request_method: 'PATCH') }

    it 'returns a Not Found Route error' do
     last_response.shall_agree_upon('hello_api.md')
     last_response.shall_agree_upon('second_api.md')
    end
  end

  describe 'support old configuration method' do
    let(:body) { "" }
    let(:endpoint){ '/message/empty' }
    let(:last_request) { RailsMocks::Request.new(fullpath: endpoint, request_method: 'POST') }

    before do
      BlueprintAgreement.configure do |c|
        c.exclude_attributes = ['name']
      end
    end

    it 'returns a Not Found Route error' do
     last_response.shall_agree_upon('hello_api.md')
    end
  end
end
