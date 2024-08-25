require "bundler/setup"
Bundler.require
require "sinatra/reloader" if development?
require "./models.rb"
require_relative "utils/date.rb"
enable :sessions

get '/' do
    if logged_in?
        @posts = Post.all
        erb :index
    else
        redirect '/signup'
    end
end

def logged_in?
    !!session[:user_id]
end

get '/signup' do
    erb :signup
end

post '/signup' do
    if User.find_by(id: params[:id]) != nil
        redirect '/signup'
        return
    end
    
    password_digest = BCrypt::Password.create(params[:password])
    
    User.create(id: params[:id], user_name: params[:user_name], email: params[:email], password_digest: params[:password_digest])
    redirect '/login' 
end


get '/login' do
    erb :login
end

post '/login' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        puts "Session user_id: #{session[:user_id]}"
        erb :index
    else
        redirect '/login'
    end
end

post '/post-content' do
    Post.create(id: SecureRandom.uuid, user_id: session[:user_id], content: params[:content],)
    redirect '/'
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