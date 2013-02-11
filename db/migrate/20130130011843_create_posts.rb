class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.references :user
      t.references :post
      t.references :category
      t.timestamps
    end
  end
end
