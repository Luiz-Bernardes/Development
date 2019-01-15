#gemset
gem 'jwt'

# jwt decoder
	# https://jwt.io/

# postman
	# method - post
		# http://localhost:3000/authentication
	# body > raw > JSON(application/json)
		# {
		# 	"name" : "Name of User"
		# }	

# routes.rb
resources :authentication, only: [:create]

# authentication_controller.rb ~> encode
class AuthenticationController < ApplicationController
	include SecretHelper 
	skip_before_action :verify_authenticity_token

	def create
		hmac_secret = secret
		payload = { name: params[:name] }
		token = JWT.encode payload, hmac_secret, 'HS256'
		render json: { token: token }
	end
end

# helpers/secret_helper.rb ~> constant secret
module SecretHelper
	def secret
		return 'my$ecretK3y'
	end
end

# helpers/authentication_helper.rb ~> decode
module AuthenticationHelper
	def authenticate
	  authenticate_or_request_with_http_token do |token, options|
	    hmac_secret = secret
	    JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
	  end
	end
end

# in controllers for authenticate
include AuthenticationHelper 
before_action :authenticate

# postman
	# method - get
		# http://localhost:3000/user
	# headers
		# key
			# Authorization
		# value 
			# Bearer eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiSGVuZGVsIn0.z_hU1Xun....
