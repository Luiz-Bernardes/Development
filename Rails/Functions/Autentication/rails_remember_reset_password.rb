#bash
rails g migration add_auth_token_to_users auth_token:string
rake db:migrate
rails g controller password_resets new
rails g migration add_password_reset_to_users password_reset_token:string password_reset_sent_at:datetime
rails g mailer user_mailer password_reset

#models/user.rb
before_create { generate_token(:auth_token) }

def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!
  UserMailer.password_reset(self).deliver
end

def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end


#application_controller.rb
def current_user
  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
end

# sessions_controller.rb
def create
  user = User.find_by_email(params[:email])
  if user && user.authenticate(params[:password])
    if params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
    redirect_to root_url, :notice => "Logged in!"
  else
    flash.now.alert = "Invalid email or password"
    render "new"
  end
end

def destroy
  cookies.delete(:auth_token)
  redirect_to root_url, :notice => "Logged out!"
end

#config/routes.rb
get "logout" => "sessions#destroy", :as => "logout"
get "login" => "sessions#new", :as => "login"
get "signup" => "users#new", :as => "signup"
root :to => "home#index"
resources :users
resources :sessions
resources :password_resets


# password_resets_controller.rb
def create
  user = User.find_by_email(params[:email])
  user.send_password_reset if user
  redirect_to root_url, :notice => "Email sent with password reset instructions."
end

def edit
  @user = User.find_by_password_reset_token!(params[:id])
end

def update
  @user = User.find_by_password_reset_token!(params[:id])
  if @user.password_reset_sent_at < 2.hours.ago
    redirect_to new_password_reset_path, :alert => "Password reset has expired."
  elsif @user.update_attributes(params[:user])
    redirect_to root_url, :notice => "Password has been reset!"
  else
    render :edit
  end
end

# sessions/new.html.erb
<p><%= link_to "forgotten password?", new_password_reset_path %></p>
<div class="field">
  <%= check_box_tag :remember_me, 1, params[:remember_me] %>
  <%= label_tag :remember_me %>
</div>


#password_resets/new.html.erb
<%= form_tag password_resets_path, :method => :post do %>
  <div class="field">
    <%= label_tag :email %>
    <%= text_field_tag :email, params[:email] %>
  </div>
  <div class="actions"><%= submit_tag "Reset Password" %></div>
<% end


#password_resets/edit.html.erb
<%= form_for @user, :url => password_reset_path(params[:id]) do |f| %>
  <% if @user.errors.any? %>
    <div class="error_messages">
      <h2>Form is invalid</h2>
      <ul>
        <% for message in @user.errors.full_messages %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
  <div class="field">
    <%= f.label :password %>
    <%= f.password_field :password %>
  </div>
  <div class="field">
    <%= f.label :password_confirmation %>
    <%= f.password_field :password_confirmation %>
  </div>
  <div class="actions"><%= f.submit "Update Password" %></div>
<% end

#config/evinroments/development.rb
config.action_mailer.default_url_options = { :host => "localhost:3000" }

#user_mailer.rb
def password_reset(user)
  @user = user
  mail :to => user.email, :subject => "Password Reset"
end

#user_mailer/password_reset.text.erb
To reset your password, click the URL below.

<%= edit_password_reset_url(@user.password_reset_token) %>

If you did not request your password to be reset, just ignore this email and your password will continue to stay the same.


#smtp config
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => 'email',
    :password             => 'password',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }



