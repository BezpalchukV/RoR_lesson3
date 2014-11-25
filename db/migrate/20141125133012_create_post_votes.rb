class CreatePostVotes < ActiveRecord::Migration
  def change
    create_table :post_votes do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :value

      t.timestamps
    end

    add_index :post_votes, [:user_id, :post_id], :unique => true
    add_index :post_votes, :user_id
    add_index :post_votes, :post_id
  end
end
