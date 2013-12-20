class CreateLikesTable < ActiveRecord::Migration
  def up
  	create_table :likes do |t| 
  		t.integer :user_id
  		t.integer :post_id
  		t.timestamps
  	end
  end

  def down
  	drop_table :likes
  end
end
