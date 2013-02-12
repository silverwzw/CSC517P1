require File.dirname(__FILE__) + '/../test_helper'

class VotesControllerTest < ActionController::TestCase

  test "should vote" do
    session[:user_id] = 2
    post :api_add, id: 2
    assert Vote.find_by_user_id_and_post_id(2, 2)
  end

  test "should not vote" do
    session[:user_id] = 1
    post :api_add, id: 2
    assert_nil Vote.find_by_user_id_and_post_id(1, 2)
  end

  test "should destroy vote" do
    session[:user_id] = 1
    assert_difference('Vote.count', -1) do
      delete :api_delete, id: 1
    end
  end
end
