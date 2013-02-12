require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { :name => "New", :password => "new" }
    end

    assert User.find_by_name("New")
  end

  test "should show user" do
    session[:user_id] = 2
    get :show, id: 2
    assert_response :success
  end

  test "should get edit" do
    session[:user_id] = 2
    get :edit, id: 2
    assert_response :success
  end

  test "should update user" do
    session[:user_id] = 2
    put :update, id: 2, user: { name: "new", password: "eric" }
    assert User.find_by_name("new")
  end

  test "should destroy user" do
    session[:user_id] = 2
    assert_difference('User.count', -1) do
      delete :destroy, id: 2
    end

    assert_redirected_to users_path
  end

  test "should login" do
    post :login, user: {name: "Eric", password: "eric"}
    assert session[:user_id] = 2
  end

  test "should logout" do
    post :login, user: {name: "logout"}
    assert session[:user_id] = -1
  end

  test "should fail" do
    post :login, user: {name: "Eric", password: "derp"}
    assert session[:user_id] != 2
  end

  test "should list" do
    @users = get :api_list
    assert @users = User.all
  end


end
