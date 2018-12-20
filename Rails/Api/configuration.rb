# only api rails application
$ rails new my_api --api
	> In config/application.rb 
		config.api_only = true

# config/environments/development.rb, ~> format exeption responses
config.debug_exception_response_format = :default
config.debug_exception_response_format = :api

# application_controller.rb
class ApplicationController < ActionController::API