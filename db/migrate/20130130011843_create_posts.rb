class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.references :User
      t.references :parent
      t.timestamps
    end
  end
end
