helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

before 'posts/new' do
  redirect to ('/login') unless logged_in?
end

post '/comments' do
  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]

  comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })
  
  comment.save
  
  redirect(back)
 
end

post '/likes' do
  finstagram_post_id = params[:finstagram_post_id]

  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
  like.save

  redirect(back)
end

delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:"finstagram_posts/new")
end

get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find(params[:id])
  erb(:"finstagram_posts/show") 
#  escape_html @finstagram_post.inspect 
end

get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  erb(:index)
end

get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  @current_user = User.find_by(id: session[:user_id])
  erb(:index)
end

get '/login' do
  erb(:login)
end

get '/logout' do
  session[:user_id] = nil
  redirect to '/'
#  "Logout successful!"
end

post '/finstagram_posts' do
  photo_url = params[:photo_url]

  @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })
                                     
  if @finstagram_post.save
    redirect(to('/'))
  else
    erb(:"finstagram_posts/new")
  end
end

post '/login' do
  username = params[:username]
  password = params[:password]

  user = User.find_by(username: username)  
 
  if user && user.password == password
    session[:user_id] = user.id
    redirect to '/'
#    "Success! User with id #{session[:user_id]} is logged in!"
  else
    @error_message = "Login Failed"
    erb(:login)
  end
end

get '/signup' do     # if a user navigates to the path "/signup",
  @user = User.new   # setup empty @user object
  erb(:signup)       # render "app/views/signup.erb"
end

post '/signup' do
#  params.to_s -->
  email =       params[:email]
  avatar_url =  params[:avatar_url]
  username =    params[:username]
  password =    params[:password]
  
 @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

 if @user.save
   redirect to '/login'
#   "User #{username} saved!"
 else
   erb(:signup)
 end
 
# if user.save 
#    escape_html user.inspect
#  else
#    escape_html user.errors.full_messages
#end

#  if email.present? && avatar_url.present? && username.present? && password.present?
#    user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
#    user.save
#  
#    escape_html user.inspect
#  else
#    Validation Failed
#  end

end