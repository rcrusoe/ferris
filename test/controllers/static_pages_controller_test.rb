require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Ferris | Your Personal Guide to the City"
  end

  test "should get terms" do
    get :terms
    assert_response :success
    assert_select "title", "Terms of Service"
  end

end
