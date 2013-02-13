class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html {redirect_to "/"}
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
      format.html
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    unless User.is_login? session
      respond_to do |format|
        format.html { redirect_to "/" }
      end
    end
    params[:post][:user] = User.find(session[:user_id])
    params[:post][:category] = Category.find(params[:post][:category])
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to "/msg.html?Post_Created!" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    if (User.is_admin? session) || (session[:user_id].to_s == @post.user.id.to_s)
      params[:post][:category] = Category.find(params[:post][:category])
      respond_to do |format|
        if @post.update_attributes(params[:post])
          format.html { redirect_to "/"}
        else
          format.html { render action: "edit" }
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to ("/msg.html?You_cannot_edit_that_post")}
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
      users = User.where("name = ?", params[:user])
      if users.count > 0
        params[:user] = users[0].id
      else
        params[:user] = -1
      end
      condition += " AND User_id = :user"
    end
    if params[:keyword] != nil
      params[:keyword] = "%" + params[:keyword] + "%"
      condition += " AND content LIKE :keyword"
    end
    @posts = Post.where(condition, params).order("updated_at DESC")
  end

  def api_reply
    if User.is_login? session
      if params[:id] == nil
        post = Post.find(params[:post_id])
        Post.new({:content => params[:content], :user => User.find(session[:user_id]), :post => post}).save
        post.updated_at = Time.now
        post.save
      else
        post = Post.find(params[:id])
        if (!User.is_admin? session) && (session[:user_id] != post.user.id)
          @result = false
          return
        end
        post.content = params[:content]
        post.save
      end
      @result = true
    else
      @result = false
    end
  end
end
