class Category < ActiveRecord::Base
  attr_accessible :name, :posts

  has_many :posts, :class_name => 'Post'
end
