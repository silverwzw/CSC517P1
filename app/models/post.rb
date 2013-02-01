class Post < ActiveRecord::Base
  attr_accessible :content, :user, :parent
  belongs_to :user
  belongs_to :parent, class_name => 'Post'
  has_many :vote
end
