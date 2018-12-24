class UserController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    render json: @users
    # render json: @users, status: :ok
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end
end