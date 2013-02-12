require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase

  test "should get index" do
    get(:index)
    assert_response(302)
  end

  test "should get new" do
    get(:new)
    assert_response(200)
  end

  test "should create post" do
    session[:user_id] = 2
    assert_difference('Post.count') do
      post(:create, :post => { :title => 'Hi', :content => 'This is a test post.', :category => 1})
    end

    assert_not_nil Post.find_by_title("Hi")
  end

  test "should show post" do
    get(:api_show, :id => 1)
    assert_response(200)
  end

  test "should get edit" do
    session[:user_id] = 2
    get(:edit, :id => 1)
    assert_response(200)
  end

  test "should update post" do
    session[:user_id] = 4
    session[:content] = nil
    put(:update, {:id => 2, :post => [:content => "Changed this one", :category => 2]})
    assert Post.find_by_content("Changed this one")
  end

  test "should destroy post" do
    session[:user_id] = 1
    assert_difference('Post.count', -1) do
      assert delete(:api_delete, :id => 2)
    end

  end
end
