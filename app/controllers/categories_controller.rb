class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json
  def index
    if User.is_admin? session
      @categories = Category.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    if User.is_admin? session
      @category = Category.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    if User.is_admin? session
      @category = Category.new
      respond_to do |format|
        format.html # new.html.erb
      end
    end
  end

  # GET /categories/1/edit
  def edit
    if User.is_admin? session
      @category = Category.find(params[:id])
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    if User.is_admin? session
      @category = Category.new(params[:category])
      if Category.where("name = ?", @category.name).count > 0
        respond_to do |format|
          format.html { redirect_to @category, notice: 'Duplicate category name!' }
        end
        return
      end

      respond_to do |format|
        if @category.save
          format.html { redirect_to @category, notice: 'Category was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    if User.is_admin? session
      @category = Category.find(params[:id])
      if @category.name == "Other"
        respond_to do |format|
          format.html  { redirect_to @category, notice: 'Default Category cannot be edited.' }
        end
        return
      end
      respond_to do |format|
        if @category.update_attributes(params[:category])
          format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    if User.is_admin? session
      @category = Category.find(params[:id])
      if @category.name == "Other"
        respond_to do |format|
          format.html  { redirect_to @category, notice: 'Default Category cannot be deleted.' }
        end
        return
      end
      o = Category.where("name = \"Other\"")[0];
      @category.posts.each do |p|
        p.category = o
        p.save
      end


      @category.destroy

      respond_to do |format|
        format.html { redirect_to categories_url }
      end
    end
  end

  def api_list
    @categories = Category.all
  end
end
