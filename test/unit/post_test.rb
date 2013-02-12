require File.dirname(__FILE__) + '/../test_helper'

class PostTest < Test::Unit::TestCase
  # test "the truth" do
  #   assert true
  # end

  def test_votes_json_1
    json_string = Post.find(1).votes_json
    assert json_string == '[1]'
  end

  def test_votes_json_2
    json_string = Post.find(2).votes_json
    assert json_string == '[3,2]'
  end

  def test_votes_json_3
    json_string = Post.find(3).votes_json
    assert json_string == '[]'
  end
end
