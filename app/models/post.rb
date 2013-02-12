class Post < ActiveRecord::Base
  attr_accessible :content, :user, :post, :title, :posts, :votes, :category
  belongs_to :user, :class_name => 'User'
  belongs_to :post, :class_name => 'Post'
  belongs_to :category, :class_name => 'Category'
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

  def self.displayable(str)
    if str == nil
      return ""
    end
    return str.gsub("&","&amp;").gsub("<","&lt;").gsub(">","&gt;").gsub("\r\n","<p />").gsub("\n","<br />").gsub("\r","<br />")
  end
end
