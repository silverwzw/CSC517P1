class ApplicationController < ActionController::Base
  protect_from_forgery
  def db_reset
    post_del
    vote_del
    user_del
    category_del
    (user_map = {
        1 => User.new({:name => "u1", :password => "u1p"}),
        2 => User.new({:name => "u2", :password => "u2p"}),
        3 => User.new({:name => "u3", :password => "u3p"}),
        :admin => User.new({:name => "admin", :password => "admin"})
    }).each { |usr| usr[1].save}
    (category_map = {
        1 => Category.new({:name => "Category 1"}),
        2 => Category.new({:name => "Category 2"})
    }).each {|cat| cat[1].save}
    (post_map = {
        1 => Post.new({:post => nil, :title => "p1", :content => "p1c", :user => user_map[3], :category => category_map[1]}),
        2 => Post.new({:post => nil, :title => "p2", :content => "p2c kw1", :user => user_map[1], :category => category_map[2]}),
        3 => Post.new({:post => nil, :title => "p3", :content => "p3c", :user => user_map[1], :category => category_map[2]})
    }).each {|pst| pst[1].save}
    Post.new({:post => post_map[1], :title => "c1", :content => "c1c", :user => user_map[1]}).save()
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
end
