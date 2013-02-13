require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase

  test "should get index" do
    session[:user_id] = 4
    get(:index)
    assert_response(200)
  end

  test "should get new" do
    session[:user_id] = 4
    get(:new)
    assert_response(200)
  end

  test "should create category" do
    session[:user_id] = 4
    get :create, category: {name: "Cool Stuff"}
    assert_response(302)
  end

  test "should show post" do
    session[:user_id] = 4
    get :show, id: 1
    assert_response(200)
  end

  test "should get edit" do
    session[:user_id] = 4
    get(:edit, :id => 1)
    assert_response(200)
  end

  test "should update category" do
    session[:user_id] = 4
    put :update, id: 2, category: {name: "Random"}
    assert Category.find_by_name("Random")
  end

  test "should destroy category" do
    session[:user_id] = 4
    assert_difference('Category.count', -1) do
      delete :destroy, id: 2
    end

  end
end
