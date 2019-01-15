#config/application.rb
module Project
  class Application < Rails::Application
    # Set language
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = :'pt-BR'
    
    # Get all directories
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
