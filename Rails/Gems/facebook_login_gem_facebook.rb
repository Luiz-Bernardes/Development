#gemfile
gem 'omniauth'
gem 'omniauth-facebook'


#config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  # FACEBOOK_APP_KEY
  # ACEBOOK_APP_SECRET
  provider :facebook, '293166381115518', '7d803f52f4ab91f9db756d551545ea81', :scope => "email"
end


#generate user model
$ rails g model User name:string email:string access_token:string uid:string photo_url:string provider:string
rake db:migrate

#generate controller session
 $ rails g controller Sessions

  class SessionsController < ApplicationController
    def create
      auth = request.env["omniauth.auth"]
      user = User.find_or_create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_path
    end

   def failure
     redirect_to root_url
   end

   def destroy
     session[:user_id] = nil
     redirect_to root_url, :notice => "Volte em breve!"
    end
   end


#routes
match "/auth/:provider/callback" => "sessions#create", :via => [:get, :post], as: :auth_callback
match "/auth/failure" => "sessions#failure", :via => [:get, :post], as: :auth_failure
match "/logout" => "sessions#destroy", :via => [:get, :post], as: :logout

#user model
class User < ApplicationRecord
  def self.find_or_create_with_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.name     = auth.info.name
      user.save
    end
  end
end


#user controller
class UsersController < ApplicationController
  def new
  end
end


#login
= link_to "Login com Facebook", "/auth/facebook"
#logout
= link_to "Logout", "/logout"


#application controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      session.delete(:user_id)
      nil
  end

  def user_signed_in?
    !current_user.nil?
  end

  def authenticate!
    user_signed_in? || redirect_to(root_url, notice: "Você precisa estar autenticado...")
  end
end