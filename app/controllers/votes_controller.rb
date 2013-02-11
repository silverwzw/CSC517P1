class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])
    @vote.user_id = session[:user_id]

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end

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
