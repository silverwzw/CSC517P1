require File.dirname(__FILE__) + '/../test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all

  # test "the truth" do
  #   assert true
  # end

  test "Login and browse site" do
    post "/users/login", user: {name: "Eric", password: "eric"}
    assert session[:user_id] == 2
    follow_redirect!
    assert "%2Findex.html" == path
    get "/posts/api_list"
    assert_response :success
    post "/posts", post: {title: "New Post", content: "new stuff", category: 1}
    assert Post.find_by_title("New Post")
    post "/votes/api_add", id: 2
    assert Vote.find_by_user_id_and_post_id(2,2)
    post "/posts/api_reply", {post_id: 2, content: "This is a comment."}
    assert Post.find_by_content("This is a comment.")
    post"/users/login", user: {name: "logout"}
    assert session[:user_id] = -1
  end

  #CustomDsl module from Rails tutorial testing page.
  module CustomDsl
    def browses_site
      get "/"
      assert_response :success
      assert assigns(:posts)
    end
  end

  def login(user)
    open_session do |sess|
      sess.extend(CustomDsl)
      sess.post "/users/login", user: {name: user.name, password: user.password}
    end
  end

end
