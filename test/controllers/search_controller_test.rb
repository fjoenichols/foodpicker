require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get pick" do
    get search_pick_url
    assert_response :success
  end

end
