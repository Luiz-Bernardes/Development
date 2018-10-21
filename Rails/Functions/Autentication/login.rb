#routes
get    '/signup',  to: 'users#new', as: :signup
get    '/login',   to: 'sessions#new', as: :new
post   '/login',   to: 'sessions#create_user_session', as: :create
match "/logout" => "sessions#destroy", :via => [:get, :post], as: :logout

#user model // ADD login, password, password_confirmation, password_digest to USER
class User < ApplicationRecord

  # before_save { self.email = email.downcase }
  # validates :name,  presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  # validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end

#user controller
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      flash[:success] = "Usuário criado com sucesso!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :login, :password,:password_confirmation)
    end

end


#session controller
class SessionsController < ApplicationController

  def create_user_session
    user = User.find_by(login: params[:session][:login].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:danger] = 'Invalid login/password combination' # Not quite right!
      render 'new'
    end
  end

  def failure
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Volte em breve!"
  end

 end


#login
= simple_form_for :session, url: create_user_session_sessions_path, method: :post, defaults: { input_html: { class: 'form-control' } } do |f|
  = f.input :login, label: false
  = f.input :password, label: false
  = f.submit 'Login', class: 'facebook-min-bt'
#logout
= link_to "Logout", "/logout"


 #session helper //OPTIONAL
 module SessionsHelper
   def log_in user
     session[:user_id] = user.id
   end

   def log_out
     session.delete(:user_id)
     @current_user = nil
   end

   def logged_in?
     !session[:user_id].nil?
   end
 end
