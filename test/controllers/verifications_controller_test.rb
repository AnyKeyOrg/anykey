require "test_helper"

class VerificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get verifications_new_url
    assert_response :success
  end
end
