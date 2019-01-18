# config
gem 'devise'
bundle
rails generate devise:install

# config/environments/development.rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

# generate devise model
rails generate devise MODEL
rails db:migrate

# limit controller(optional)
before_action :authenticate_user!
user_signed_in? # To verify if a user is signed in, use the following helper:
current_user # For the current signed-in user, this helper is available:
user_session # You can access the session for this scope:

# config/initializers/rails_admin.rb
RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

end

# create first admin
Admin.create! email: 'admin@admin.com', password: '123456'

