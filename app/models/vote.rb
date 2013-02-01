class Vote < ActiveRecord::Base
  attr_accessible :post, :user
  belongs_to :post
  belongs_to :user
end
