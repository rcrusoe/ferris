require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get homoe" do
    get :homoe
    assert_response :success
  end

end
