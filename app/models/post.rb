class Post < ActiveRecord::Base
  attr_accessible :content, :user, :post, :title
  belongs_to :user, :class_name => 'User'
  belongs_to :post, :class_name => 'Post'
  has_many :posts, :class_name => 'Post'
  has_many :votes, :class_name => "Vote"
end
