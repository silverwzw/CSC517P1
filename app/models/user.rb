class User < ActiveRecord::Base
  attr_accessible :name, :password
  has_many :posts, :class_name => "Post"
  has_many :votes, :class_name => "Vote"

  def self.is_login?
    if session[:user_id].nil?
      session[:user_id] = -1
    end
    return (session[:user_id] >= 0)
  end

  def self.is_user?(username)
    if !(is_login?)
      return false
    end
    return (User.find(session[:user_id]).name == username)
  end

  def self.is_admin?
    return is_user?("admin")
  end
end
