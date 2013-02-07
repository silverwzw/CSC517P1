class Post < ActiveRecord::Base
  attr_accessible :content, :user, :post, :title, :posts, :votes
  belongs_to :user, :class_name => 'User'
  belongs_to :post, :class_name => 'Post'
  has_many :posts, :class_name => 'Post'
  has_many :votes, :class_name => "Vote"

  def votes_json
    @js_str = "["
    votes.find_each { |vt|
      @js_str += vt.user.id.to_s + ","
    }
    @js_str += "]"
    return @js_str
  end
end
