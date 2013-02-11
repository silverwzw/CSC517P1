class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
#     format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def api_show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
#     format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
#       format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
#       format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
#       format.json { head :no_content }
      else
        format.html { render action: "edit" }
#       format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def api_delete
    post = Post.find(params[:id])
    if post.post == nil
      @parent = nil
    else
      @parent = post.post.id
    end
    if User.is_admin?(session) || User.is_user?(session, post.user.name)
      post.votes.each {|v| v.destroy}
      post.posts.each {|c| c.destroy}
      post.destroy
      @result = true
      return
    end
    @result = false
  end

  def api_list
    condition = "Post_id IS NULL"
    if params[:category] != nil
      condition += " AND Category_id = :category"
    end
    if params[:user] != nil
      condition += " AND User_id = :user"
    end
    if params[:keyword] != nil
      params[:keyword] = "%" + params[:keyword] + "%"
      condition += " AND content LIKE :keyword"
    end
    @posts = Post.where(condition, params).order("updated_at DESC");
  end
end
