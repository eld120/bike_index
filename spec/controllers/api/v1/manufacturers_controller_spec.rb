require "rails_helper"

RSpec.describe API::V1::ManufacturersController, type: :controller do
  describe "index" do
    it "loads the request" do
      m = FactoryBot.create(:manufacturer, name: "AAAA manufacturer")
      get :index, format: :json
      expect(response.code).to eq("200")
      expect(json_result["manufacturers"].first["name"]).to eq(m.name)
      expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(response.headers["Access-Control-Allow-Methods"]).to eq("POST, PUT, GET, OPTIONS")
      expect(response.headers["Access-Control-Request-Method"]).to eq("*")
      expect(response.headers["Access-Control-Allow-Headers"]).to eq("Origin, X-Requested-With, Content-Type, Accept, Authorization")
      expect(response.headers["Access-Control-Max-Age"]).to eq("1728000")
    end
  end
end
