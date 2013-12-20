require 'sinatra/activerecord/rake'
require_relative 'config'
require_relative 'models/post'
require_relative 'models/user'
require_relative 'models/comment'


namespace :db do 

	desc "clear out database records" 
	task :clear do 
		Post.delete_all
		User.delete_all
		Comment.delete_all
	end

end