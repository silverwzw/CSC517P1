class Post < ActiveRecord::Base
  attr_accessible :content, :user, :post, :title, :posts, :votes, :category
  belongs_to :user, :class_name => 'User'
  belongs_to :post, :class_name => 'Post'
  belongs_to :category, :class_name => 'Category'
  has_many :posts, :class_name => 'Post'
  has_many :votes, :class_name => "Vote"

  def votes_json
    @js_str = "["
    (1..votes.size).each { |i|
      if (votes[i-1].user == nil)
        @js_str += "-2"
      else
        @js_str += votes[i-1].user.id.to_s
      end
      if i != votes.size
        @js_str += ","
      end
    }
    @js_str += "]"
  end

  def self.displayable(str)
    if str == nil
      return ""
    end
    return str.gsub("&","&amp;").gsub("<","&lt;").gsub(">","&gt;").gsub("\r\n","<p />").gsub("\n","<br />").gsub("\r","<br />")
  end

  def delete_recursive
    posts.each {|c| c.delete_recursive}
    votes.each {|v| v.destroy}
    self.destroy
  end
end
