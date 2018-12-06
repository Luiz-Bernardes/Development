# bash - This should create the following migration file (please note the addition of :default => false which will need to be done manually):
rails generate migration add_email_confirm_column_to_users email_confirmed:boolean confirm_token:string

# migration
class AddEmailConfirmColumnToUsers <     ActiveRecord::Migration
  def change
    add_column :users, :email_confirmed, :boolean, :default => false
    add_column :users, :confirm_token, :string
  end
end

# bash
rake db:migrate

# routes
resources :users do
  member do
    get :confirm_email
  end
end

# controllers/mailers/user_mailer
class UserMailer < ActionMailer::Base
    default :from => "me@mydomain.com"

 def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registration Confirmation")
 end

 # views/user_mailer/registration_confirmation.text.erb
 Hi <%= @user.name %>,

 Thanks for registering! To confirm your registration click the URL below.

 <%= confirm_email_user_url(@user.confirm_token) %>

 # models/user.rb
 before_create :confirmation_token

 private
 def confirmation_token
   if self.confirm_token.blank?
     self.confirm_token = SecureRandom.urlsafe_base64.to_s
   end
 end

# controllers/users_controller.rb
def create
  @user = User.new(user_params)
  if @user.save
    UserMailer.registration_confirmation(@user).deliver
    flash[:success] = "Please confirm your email address to continue"
    redirect_to root_url
  else
    flash[:error] = "Ooooppss, something went wrong!"
    render 'new'
  end
end

# controllers/sessions_controller.rb
def create
  user = User.find_by_email(params[:email].downcase)
  if user && user.authenticate(params[:password])
  if user.email_confirmed
      sign_in user
    redirect_back_or user
  else
    flash.now[:error] = 'Please activate your account by following the
    instructions in the account confirmation email you received to proceed'
    render 'new'
  end
  else
    flash.now[:error] = 'Invalid email/password combination' # Not quite right!
    render 'new'
  end
end

# controllers/users_controller.rb
def confirm_email
  user = User.find_by_confirm_token(params[:id])
  if user
    user.email_activate
    flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
    Please sign in to continue."
    redirect_to signin_url
  else
    flash[:error] = "Sorry. User does not exist"
    redirect_to root_url
  end
end

# model/client.rb
def email_activate
  self.email_confirmed = true
  self.confirm_token = nil
  save!(:validate => false)
end


# development.rb
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain => 'localhost:3000',
  :user_name            => 'vertvsite@gmail.com',
  :password             => 'vertvacesso111tocanet',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }

  config.action_mailer.default_url_options = { :host => "localhost:3000" }