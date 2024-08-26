require "bundler/setup"
Bundler.require
require "sinatra/reloader" if development?
require "./models.rb"
require_relative "utils/date.rb"
enable :sessions

get '/' do
    if logged_in?
        @posts = Post.all.order(created_at: :desc)
        erb :index
    else
        redirect '/login'
    end
end

def logged_in?
    !!session[:user_id]
end

get '/signup' do
    erb :signup
end

post '/signup' do
    user = User.create(name: params[:name], email: params[:email], password: params[:password])
    
    if user.persisted?
        session[:user] = user.id
        redirect '/'
    else
        redirect '/signup'
    end
end

get '/login' do
    erb :login
end

post '/login' do
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/'
    else
        redirect '/login'
    end
end

post '/post-content' do
    Post.create(user_id: session[:user_id], content: params[:content])
    redirect '/'
end

get '/posts/:id' do
    @post = Post.find_by(id: params[:id])
    if @post
        @comments = @post.comments
        erb  :comment
    end
end

post '/comments' do
    Comment.create(post_id: params[:post_id], user_id: session[:user_id], content: params[:content])
    redirect "/posts/#{params[:post_id]}"
end

get '/comment/:post_id' do
    @post = Post.find_by(id:params[:post_id])
    @user_id = session[:user_id]
    @comments = @post.comment
    erb :comment
end

post '/comment/add' do
    Comment.create(id:SecureRandom.uuid, post_id: params[:post_id], user_id: params[:user_id], content: params[:content])
    redirect "/comment/#{params[:post_id]}"
end

get '/logout' do
    session.clear
    redirect '/login'
end