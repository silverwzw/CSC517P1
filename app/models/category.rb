class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :posts, :class_name => 'Post'
end
