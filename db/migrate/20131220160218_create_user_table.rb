class CreateUserTable < ActiveRecord::Migration
  def change
  	create_table :users do |t| 
  		t.string :username
  		t.string :astrological_sign
  		t.timestamps
  		t.string :tagline
  	end
  end
end
