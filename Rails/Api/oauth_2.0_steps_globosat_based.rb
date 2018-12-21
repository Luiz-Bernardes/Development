# gemfile
gem 'doorkeeper'
gem 'rest-client'

$ rails generate doorkeeper:install
$ rails generate doorkeeper:migration
$ rake db:migrate

--------------------------------------------------------------------------------

# url de chamada do cliente - sem parâmetros
# index.html.erb
<%= link_to 'Authorize via Keepa', new_oauth_token_path %>

# url de chamada do cliente
# http://localhost:3000/oauth/authorize?client_id=38b519b68f61a8ca0ded6d927f18954d750d510e92f9f4e83b3646da6afad09b&redirect_uri=https%3A%2F%2Fwww.getpostman.com%2Foauth2%2Fcallback&response_type=code&scope=public+write

# routes.rb
get '/authorize', to: 'doorkeeper/authorizations#new' , as: 'authorize_new'
post '/authorize', to: 'doorkeeper/authorizations#create' , as: 'authorize_create'

--------------------------------------------------------------------------------

# usuário faz login

# routes.rb
resources :clients, only: [:new, :create]
resources :sessions, only: [:new]
post '/create', to: 'doorkeeper/sessions#create' , as: 'authorize_sessions_create'

# app/views/sessions/new.html.erb
<div class="panel panel-default devise-bs" style="width:330px;margin:260px auto;">
  <div class="panel-heading">
    <h4 style="text-align: center;"><%= t('.sign_in', default: 'Login Oauth') %></h4>
  </div>
  <div class="panel-body">
    <%= form_tag authorize_sessions_create_path, method: :post do %>
      <div style="text-align: center;" class="form-group">
        E-mail
        <%= email_field_tag :email %>
      </div>
      <div style="text-align: center;" class="form-group">
        Senha
        <%= password_field_tag :password %>
      </div>
      <%= submit_tag 'Entrar', class: 'btn btn-primary', style: 'margin-left: 40%;margin-top: 3px;' %>
    <% end %>
  </div>
</div>

<style type="text/css">
  input{
    margin-left: 5px;
  }
</style>

--------------------------------------------------------------------------------

# redirecionamento de fluxo para a url definida

#app/controllers/doorkeeper/sessions_controller.rb
module Doorkeeper
  class SessionsController < Doorkeeper::ApplicationController

    def create
      @user = Client.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        # oauth_token
        session[:user_id] = @user.id
        flash[:success] = "Welcome back!"
        oauth = OauthApplication.first

        url_redirect = request.base_url + "/oauth/authorize?"
        url_redirect +=  "client_id=#{oauth.uid}&"
        url_redirect +=  "redirect_uri=#{oauth.redirect_uri}&"
        url_redirect +=  "response_type=code&"
        url_redirect +=  "scope=public+write"

        redirect_to url_redirect


        # http://localhost:3000/oauth/authorize?
        # client_id=38b519b68f61a8ca0ded6d927f18954d750d510e92f9f4e83b3646da6afad09b&
        # redirect_uri=https%3A%2F%2Fwww.getpostman.com%2Foauth2%2Fcallback&
        # response_type=code&
        # scope=public+write

      else
        flash[:warning] = "You have entered incorrect email and/or password."
        render :new
      end
    end

    def not_authorized
    end

  end
end

--------------------------------------------------------------------------------

post token

# routes.rb
post '/token', to: 'doorkeeper/tokens#create' , as: 'token'

# app/controllers/doorkeeper/tokens_controller.rb   ~> override gem, custom method
module Doorkeeper
  class TokensController < Doorkeeper::ApplicationMetalController
    def create
      response = authorize_response
      headers.merge! response.headers

      client = Client.find(authorize_response.token.resource_owner_id)
      client_id = client.id
      client_name = client.email.split("@")
      client_cpf = client.cpf
      client_email = client.email

      self.response_body = "{\"access_token\":\"#{authorize_response.token.token}\",\"token_type\":\"bearer\",\"expires_in\": #{authorize_response.token.expires_in},\"refresh_token\":\"#{authorize_response.token.refresh_token}\",\"refresh_token_expires_in\": #{authorize_response.token.expires_in},\"scope\":\"#{authorize_response.token.scopes}\",\"created_at\":#{authorize_response.token.created_at.strftime("%s")},\"uid\": #{authorize_response.token.resource_owner_id},\"nome\":\"#{client_name[0]}\",\"email\":\"#{client_email}\",\"cpf\":\"#{client_cpf}\" }"

      # self.response_body = response.body.to_json

      self.status = response.status
    rescue Errors::DoorkeeperError => e
      handle_token_exception e
    end

    # OAuth 2.0 Token Revocation - http://tools.ietf.org/html/rfc7009
    def revoke
      # The authorization server, if applicable, first authenticates the client
      # and checks its ownership of the provided token.
      #
      # Doorkeeper does not use the token_type_hint logic described in the
      # RFC 7009 due to the refresh token implementation that is a field in
      # the access token model.
      if authorized?
        revoke_token
      end

      # The authorization server responds with HTTP status code 200 if the token
      # has been revoked successfully or if the client submitted an invalid
      # token
      render json: {}, status: 200
    end

    def introspect
      introspection = OAuth::TokenIntrospection.new(server, token)

      if introspection.authorized?
        render json: introspection.to_json, status: 200
      else
        error = OAuth::ErrorResponse.new(name: introspection.error)
        response.headers.merge!(error.headers)
        render json: error.body, status: error.status
      end
    end

    private

    # OAuth 2.0 Section 2.1 defines two client types, "public" & "confidential".
    # Public clients (as per RFC 7009) do not require authentication whereas
    # confidential clients must be authenticated for their token revocation.
    #
    # Once a confidential client is authenticated, it must be authorized to
    # revoke the provided access or refresh token. This ensures one client
    # cannot revoke another's tokens.
    #
    # Doorkeeper determines the client type implicitly via the presence of the
    # OAuth client associated with a given access or refresh token. Since public
    # clients authenticate the resource owner via "password" or "implicit" grant
    # types, they set the application_id as null (since the claim cannot be
    # verified).
    #
    # https://tools.ietf.org/html/rfc6749#section-2.1
    # https://tools.ietf.org/html/rfc7009
    def authorized?
      if token.present?
        # Client is confidential, therefore client authentication & authorization
        # is required
        if token.application_id?
          # We authorize client by checking token's application
          server.client && server.client.application == token.application
        else
          # Client is public, authentication unnecessary
          true
        end
      end
    end

    def revoke_token
      if token.accessible?
        token.revoke
      end
    end

    def token
      @token ||= AccessToken.by_token(request.POST['token']) ||
        AccessToken.by_refresh_token(request.POST['token'])
    end

    def strategy
      @strategy ||= server.token_request params[:grant_type]
    end

    def authorize_response
      @authorize_response ||= strategy.authorize
    end
  end
end

--------------------------------------------------------------------------------

# informações do usuário

# routes.rb
get '/userinfo', to: 'doorkeeper/token_info#show' , as: 'userinfo'

# app/controllers/doorkeeper/token_info_controller.rb    ~> override gem, custom method
module Doorkeeper
  class TokenInfoController < Doorkeeper::ApplicationMetalController

    def show
      if doorkeeper_token && doorkeeper_token.accessible?
        id = doorkeeper_token["resource_owner_id"]
        client = Client.find(id)
        client_id = client.id
        client_name = client.email.split("@")
        client_cpf = client.cpf
        client_email = client.email

        render json: "{\"uid\": \"#{client.id}\" ,\"nome\": \"#{client_name[0]}\", \"cpf\": \"#{client_cpf}\", \"email\": \"#{client_email}\" }", status: :ok
      else
        render json: "{\"error\": \"error\" }", status: :unauthorized
      end
    end

  end
end

--------------------------------------------------------------------------------

# recursos

# routes.rb
get 'resources', to: 'resources#index', as: 'resources'

# app/controllers/resources_controller.rb
class ResourcesController < Doorkeeper::ApplicationMetalController

  def index
    if doorkeeper_token && doorkeeper_token.accessible?
      find_values
      render json: "{\"allowed\": #{@allowed}, \"not_allowed\": #{@not_allowed} }", status: :ok
    else
      render json: "{\"error\": \"error\" }", status: :unauthorized
    end
  end

  private
  def find_values
    @client = Client.find(doorkeeper_token["resource_owner_id"])

    @allowed = []
    @not_allowed = []

    packages = Package.all
    packages = packages.map(&:urn).flatten.uniq
    packages.each do |value|
      add_package(value)
    end

  end

  def add_package(urn_code)
    urn = Package.where(urn: urn_code)
    store_regs = ''
    cont = 0
    permitted = 0

    registries = Registry.where(cpf: @client.cpf)
    registries.each do |registry|
      store_regs += cont == 0 ? registry.codes : ',' + registry.codes
      cont = cont + 1;
    end

    if store_regs != ""
      code = store_regs.split(",")
      (0..code.length - 1).each do |c|
        urn.each do |u|
          if code[c] == u.pack_id
            permitted = 1
          end
        end
      end
    end

    urn_code = urn_code.split(":")
    urn_code = urn_code.last

    permitted == 1 ? @allowed.push(urn_code) : @not_allowed.push(urn_code)
  end

end

--------------------------------------------------------------------------------

# proteger tela de chamada do cliente

# get '/not_authorized', to: 'doorkeeper/sessions#not_authorized' , as: 'not_authorized_session'

# config/initializers/doorkeeper_controller.rb   ~> override gem, custom method
Doorkeeper::Helpers::Controller.module_eval do
  def authenticate_resource_owner!
    oauth = OauthApplication.first
    if (oauth.uid == params["client_id"]) && (params["redirect_uri"] == oauth.redirect_uri)
      current_resource_owner
    else
      redirect_to not_authorized_session_path
    end
  end
end

--------------------------------------------------------------------------------

# protect oauth application with devise

# app/controllers/doorkeeper/applications_controller.rb
module Doorkeeper
  class ApplicationsController < Doorkeeper::ApplicationController
    layout 'doorkeeper/admin'

    before_action :admin
    before_action :set_application, only: [:show, :edit, :update, :destroy]

    def index
      @applications = if Application.respond_to?(:ordered_by)
                        Application.ordered_by(:created_at)
                      else
                        ActiveSupport::Deprecation.warn <<-MSG.squish
                          Doorkeeper #{Doorkeeper.configuration.orm} extension must implement #ordered_by
                          method for it's models as it will be used by default in Doorkeeper 5.
                        MSG

                        Application.all
                      end
    end

    def show; end

    def new
      @application = Application.new
    end

    def create
      @application = Application.new(application_params)
      if @application.save
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :create])
        redirect_to oauth_application_url(@application)
      else
        render :new
      end
    end

    def edit; end

    def update
      if @application.update_attributes(application_params)
        flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :update])
        redirect_to oauth_application_url(@application)
      else
        render :edit
      end
    end

    def destroy
      flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
      redirect_to oauth_applications_url
    end

    private

    def admin
      if current_admin == nil
        redirect_to not_authorized_session_path
      end
    end

    def set_application
      @application = Application.find(params[:id])
    end

    def application_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes)
    end
  end
end