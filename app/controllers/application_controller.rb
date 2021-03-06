require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "hand_cramps_are_lessened"
    use Rack::Flash
  end

  get '/' do
    redirect "users/desk" if logged_in?
    erb :index
  end

  get '/login/?' do
    redirect "users/desk" if logged_in?
    erb :index
  end

  get '/logout/?' do
    session.clear
    redirect '/login'
  end

  post '/login/?' do
    @user = User.find_by(username: params[:login]) || User.find_by(email: params[:login])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/desk"
    else
      flash_message("That didn't work.", "error")
      redirect back
    end
  end

  get '/test/?' do
    log_in!
    "It works??"
  end

  helpers do
		def logged_in?
			!!current_user
		end

		def current_user
			@current_user ||= User.find(session[:user_id]) if session[:user_id]
		end

    def log_in!
      redirect '/login' unless logged_in?
    end

    def owner(obj)
      obj == current_user || obj.user == current_user
    end

    def slugged
      User.find_by_slug(params[:slug])
    end

    def flash_error(obj)
      obj.errors.messages.values.each do |v|
        flash_message(v.first, "error")
      end
    end

    def flash_message(message, type="info")
      flash[:message] ||= []
      flash[:message] << [message, type]
    end
	end #helpers

end
