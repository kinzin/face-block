require 'bundler/setup'
Bundler.require(:default)

require_relative 'models/post'
require_relative 'models/user'
require_relative 'models/comment'
require_relative 'models/like'
require_relative 'config'

enable :sessions

get '/' do
	if session[:username]
		@user = User.find_by_username(session[:username])
	else 
		@user = nil
	end
	@posts = Post.all
  @posts.sort_by! {|obj| obj.created_at}
  @posts.reverse!
	erb :index
end

post '/posts' do
  title = params[:title] || "untitled"
  body = params[:body] || " "
  code_type = params[:code_type]
  if code_type == "none"
    body = remove_script(body)
  end
  user = User.find_by_username(session[:username])
  post = Post.new(:title => title, :body => body, :code_type => code_type)
  user.posts << post
  post.save
  redirect '/'
end

get '/users/sign_up' do 
	erb :sign_up
end

get '/posts' do
  redirect '/'
end

post '/users' do 
  unless user = User.find_by_username(params[:username])
  	user = User.create(:username => params[:username], :email => params[:email])
  	session[:username] = user.username
  	redirect '/'
  else
    redirect '/users/sign_in'
  end
end

get '/users/sign_in' do 
	erb :sign_in
end

post '/users/sign_in' do 
  if user = User.find_by_username(params[:username])
  	session[:username] = user.username
  	redirect '/'
  else 
  	redirect '/users/sign_up'
  end
end

get '/users/sign_out' do 
	session[:username] = nil
	redirect '/'
end

get '/users/:id' do 
	@user = User.find(params[:id].to_i)
  @posts = @user.faves
  @posts.uniq.sort_by!
  @posts.sort_by! {|obj| obj.created_at}
  @posts.reverse!
  @welcome = false
	erb :index
end

#ADD A COMMENT
post '/posts/:id/comments' do 
	user = User.find_by_username(session[:username])
	post = Post.find(params[:id].to_i)
  body = params[:comment_text]
  body = remove_script(body)
	comment = Comment.new(:body => body)
	comment.save 
	post.comments << comment
	user.comments << comment
	redirect '/'
end 

#LIKE POST
get '/posts/:id/like' do 
  user = User.find_by_username(session[:username])
  post = Post.find(params[:id])
  user.faves << post
  redirect '/'
end

#UNLIKE POST
get '/posts/:id/unlike' do  
  user = User.find_by_username(session[:username])
  like = user.likes.find_by_post_id(params[:id]) 
  like.destroy
  redirect '/'
end

#EDIT POST
get '/posts/:id/edit' do 
  @post = Post.find(params[:id])
  erb :edit
end

post '/posts/:id' do
  post = Post.find(params[:id])
  post.title = params[:title] || "untitled"
  post.body = params[:body] || " "
  post.code_type = params[:code_type]
  if post.code_type == "none"
    post.body = remove_script(post.body)
  end 
  post.save
  redirect '/'
end

#DELETE POST
post '/posts/:id/delete' do
  post = Post.find(params[:id])
  post.comments.each do |comment|
    comment.destroy
  end
  post.destroy
  redirect "/"
end


#EDIT COMMENT
get '/comments/:id/edit' do 
  @comment = Comment.find(params[:id])
  erb :edit_comment
end

post '/comments/:id' do
  comment = Comment.find(params[:id])
  body = params[:body] || " "
  comment.body = remove_script(body)
  comment.save
  redirect '/'
end

#DELETE COMMENT
post '/comments/:id/delete' do
  comment = Comment.find(params[:id])
  comment.destroy
  redirect "/"
end




def remove_script(text)
  text.gsub("script", "") 
end

