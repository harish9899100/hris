require 'rails_helper'

RSpec.describe "LeaveRequests", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/leave_requests/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/leave_requests/new"
      expect(response).to have_http_status(:success)
    end
  end

end
