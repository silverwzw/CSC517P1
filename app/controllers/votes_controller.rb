class VotesController < ApplicationController
  def api_add
    if vote_owner?(session[:user_id], params[:id]) ||  has_voted?(session[:user_id], params[:id])
      @result = false
      return
    end
    vote = Vote.new
    vote.user = User.find(session[:user_id])
    vote.post = Post.find(params[:id])
    vote.save
    post = Post.find(params[:id])
    post.created_at = Time.now
    post.save
    @result = true
  end

  def api_delete
      @vote = Vote.where("user_id = ? AND post_id = ?", session[:user_id], params[:id])
      if (@vote.count > 0)
        @vote[0].destroy
        @result = true
        return
      end
    @result = false
  end

  def vote_owner?(u, p)
    return (Post.find(p).user_id == u)
  end

  def has_voted?(u, p)
    return (Vote.where("user_id = ? AND post_id = ?",u, p).count > 0)
  end

  private :has_voted?
  private :vote_owner?
end
