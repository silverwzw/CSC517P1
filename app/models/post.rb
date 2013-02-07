class Post < ActiveRecord::Base
  attr_accessible :content, :user, :post, :title, :posts, :votes
  belongs_to :user, :class_name => 'User'
  belongs_to :post, :class_name => 'Post'
  has_many :posts, :class_name => 'Post'
  has_many :votes, :class_name => "Vote"

  def votes_json
    @js_str = "["
    for i in (1..votes.size)
      @js_str += votes[i-1].user.id.to_s
      if (i != votes.size)
        @js_str += ","
      end
    end
    @js_str += "]"
    return @js_str
  end
end
