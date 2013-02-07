class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    if is_login?
      @username = User.find(session[:user_id]).name
    else
      @username = ""
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if !(is_login?)
      respond_to do |format|
        format.html {redirect_to "/msg.html?please_log_in_first"}
        format.json
      end
      return
    end
    @user = User.find(params[:id])
    if !(is_admin? or is_user?(@user.name))
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
    if !(is_admin? or is_user?(@user.name))
      respond_to do |format|
        format.html {redirect_to "/msg.html?you_do_not_have_required_permission"}
        format.json
      end
      return
    end
  end

  # POST /users
  # POST /users.json
  def create
    @username = params[:user][:name];
    if (@username == "logout" || @username == "login" || User.where("name = ?", @username).count > 0)
      session.clear
      respond_to do |format|
        format.html {redirect_to "/msg.html?This_username_is_not_available"}
        format.json
      end
      return
    end
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
    if !(is_admin? or is_user?(@user.name))
      respond_to do |format|
        format.html {redirect_to "/msg.html?you_do_not_have_required_permission"}
        format.json
      end
      return
    end

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
    @is_ad = is_admin?
    if !(@is_ad or is_user?(@user.name))
      respond_to do |format|
        format.html {redirect_to "/msg.html?you_do_not_have_required_permission"}
        format.json
      end
      return
    end
    @user.destroy
    if (!@is_ad)
      session.clear
    end

    respond_to do |format|
      format.html { redirect_to "/users" }
      format.json { head :no_content }
    end
  end

  # POST /users/login
  # POST /users/login.json
  def login
    if(params[:user][:name] == "logout")
      session[:user_id] = -1
      respond_to do |format|
        format.html {redirect_to "/msg?bye!"}
        format.json
      end
      return
    end
    @user = User.where("name = ?", params[:user][:name])
    if (@user.count < 1)
      respond_to do |format|
        format.html {redirect_to "/msg?no_such_user"}
        format.json
      end
      return
    end
    @user = @user.first!
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

  def is_login?
    if session[:user_id].nil?
      session[:user_id] = -1
    end
    return (session[:user_id] >= 0)
  end

  def is_user?(username)
    if !(is_login?)
      return false
    end
    return (User.find(session[:user_id]).name == username)
  end

  def is_admin?
    return is_user?("admin")
  end

  def api_list
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def api_is_admin
    @is_ad = is_admin? ? "null" : "\"admin\""
    respond_to do |format|
      format.html
    end
  end

  def api_is_login
    @is_in = is_login? ? "null" : "{\"id\":" + session[:user_id].to_s + ",\"name\":\"" + User.find(session[:user_id]).name + "\"}"
    respond_to do |format|
      format.html
    end
  end

  private :is_login?
  private :is_admin?
  private :is_user?
end
