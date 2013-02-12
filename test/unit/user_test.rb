require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_is_login
    session = Hash.new
    assert !User.is_login?(session)
    assert session[:user_id] == -1
    session[:user_id] = 1
    assert User.is_login?(session)
  end

  def test_is_user
    session = Hash.new
    username = 'Eric'
    assert !User.is_user?(session, username)
    session[:user_id] = 1
    assert !User.is_user?(session, username)
    session[:user_id] = 2
    assert User.is_user?(session, username)
  end

  def test_is_admin
    session = Hash.new
    assert !User.is_admin?(session)
    session[:user_id] = 1
    assert !User.is_admin?(session)
    session[:user_id] = 4
    assert User.is_admin?(session)
  end
end
