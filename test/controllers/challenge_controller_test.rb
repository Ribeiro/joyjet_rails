require 'test_helper'

class ChallengeControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get challenge_home_url
    assert_response :success
  end

end
