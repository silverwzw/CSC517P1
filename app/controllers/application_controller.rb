class ApplicationController < ActionController::Base
  protect_from_forgery
  def db_reset
    post_del
    vote_del
    user_del
    category_del
    (user_map = {
        1 => User.new({:name => "Steven", :password => "steven", :admin => 0}),
        2 => User.new({:name => "Eric", :password => "eric", :admin => 0}),
        3 => User.new({:name => "Jessi", :password => "jessi", :admin => 0}),
        :admin => User.new({:name => "Admin", :password => "admin", :admin => 1})
    }).each { |usr| usr[1].save}
    (category_map = {
        1 => Category.new({:name => "Project"}),
        2 => Category.new({:name => "Gossip"}),
        3 => Category.new({:name => "Other"})
    }).each {|cat| cat[1].save}
    (post_map = {
        1 => Post.new({:post => nil, :title => "Project Due", :content => "Project will due tomorrow.Gonna hurry", :user => user_map[3], :category => category_map[1]}),
        2 => Post.new({:post => nil, :title => "New Library", :content => "James Hunt Library is now open to public.....It's fantastic, everyone should go and have a try.", :user => user_map[1], :category => category_map[2]}),
        3 => Post.new({:post => nil, :title => "1st Exam is hard", :content => "ATT", :user => user_map[1], :category => category_map[2]})
    }).each {|pst| pst[1].save}
    Post.new({:post => post_map[1], :content => "Agree", :user => user_map[1], :title => "Re:Project Due"}).save()
    (vote_map = {
        1 => Vote.new({:user => user_map[1], :post => post_map[1]}),
        2 => Vote.new({:user => user_map[3], :post => post_map[2]}),
        3 => Vote.new({:user => user_map[2], :post => post_map[2]})
    }).each {|vt| vt[1].save}
    session[:user_id] = -1
    respond_to do |format|
      format.html { redirect_to "/"}
    end
  end

  def db_check
    # make sure there's at least an admin and a default category
    respond_to do |format|
      format.json {render :json => User.where("admin <> 0").count > 0 && Category.where("name = \"Other\"").count == 1}
    end
  end

  def post_del
    Post.destroy_all
  end
  def vote_del
    Vote.destroy_all
  end
  def user_del
    User.destroy_all
  end
  def category_del
    Category.destroy_all
  end

  private :post_del
  private :user_del
  private :vote_del
  private :category_del
end
