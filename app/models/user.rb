class User < ActiveRecord::Base
  attr_accessible :name, :password, :admin
  has_many :posts, :class_name => "Post"
  has_many :votes, :class_name => "Vote"

  def self.is_login?(session)
    if session[:user_id].nil?
      session[:user_id] = -1
    end
    return (session[:user_id] >= 0)
  end

  def self.is_user?(session,username)
    if !(is_login?(session))
      return false
    end
    return (User.find(session[:user_id]).name == username)
  end

  def self.is_admin?(session)
    return is_login?(session) && (User.find(session[:user_id]).admin != 0)
  end
end
