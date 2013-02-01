class Post < ActiveRecord::Base
  attr_accessible :content, :user, :post
  belongs_to :user
  belongs_to :post
  has_many :vote
end
