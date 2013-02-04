class Vote < ActiveRecord::Base
  attr_accessible :post, :user
  belongs_to :user, :class_name => "User"
  belongs_to :post, :class_name => "Post"
end
