require 'rails_helper'

RSpec.describe ExampleController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      require 'json'
      expect(response).to have_http_status(:success)
      expect(response).to shall_agree_upon('test.md')
    end
  end

end
