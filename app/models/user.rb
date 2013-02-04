class User < ActiveRecord::Base
  attr_accessible :name, :password
  has_many :posts, :class_name => "Post"
  has_many :votes, :class_name => "Vote"
end
