class UserController < ApplicationController
  
  def index
    @users = User.all
    render json: @users
    # render json: @users, status: :ok
  end

  def show
    render json: @user
  end
end