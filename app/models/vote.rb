class Vote < ActiveRecord::Base
  attr_accessible :post, :user
  belongs_to :user, :class_name => "User"
  belongs_to :post, :class_name => "Post"

  def self.is_vote_owner(u, p)
    post = Post.find(p)
    if post.user_id == u
      true
    else
      false
    end
  end

  def self.has_voted(u, p)
    true ? Vote.find_by_user_id_and_post_id(u, p) : false
  end
end
