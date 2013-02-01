class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :User
      t.references :Post
      t.timestamps
    end
  end
end
