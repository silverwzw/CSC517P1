class User < ActiveRecord::Base
  attr_accessible :name, :password, :post, :vote
  has_many :post
  has_many :vote
end
