class User < ActiveRecord::Base 
	has_many :posts
	has_many :comments
	has_many :likes

	# we are essentially aliasing .posts to .faves
	# method name       joiner table       lookup_table
	has_many :faves, :through => :likes, :source => :post
	
end
