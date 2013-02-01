class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if session[:user_id].nil? or session[:user_id] < 0
      respond_to do |format|
        format.html {redirect_to "/msg.html?please_log_in_first"}
        format.json
      end
      return
    end
    @currentUser = User.find(session[:user_id]);
    @user = User.find(params[:id])
    if @currentUser.name != "admin" and @currentUser.name != @user.name
      respond_to do |format|
        format.html {redirect_to "/msg.html?you_do_not_have_required_permission"}
        format.json
      end
    else
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @user }
        end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # POST /users/login
  # POST /users/login.json
  def login
    @user = User.where("name = ?", params[:user][:name]).first!
    if @user.password == params[:user][:password]
      session[:user_id] = @user.id
      respond_to do |format|
        format.html {redirect_to "/posts"}
        format.json
      end
    else
      session.clear
      respond_to do |format|
        format.html {redirect_to "/msg.html?login_failed!"}
        format.json
      end
    end
  end
end
