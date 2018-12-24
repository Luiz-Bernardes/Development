class UserController < ApplicationController 
  def index
    @users = User.all
    render json: @users
    # render json: @users, status: :ok
  end

  # status: :status 
  # root: boolean
  # only: [:field ,..]
  # except: [:field, ..]

  def show
    render json: @user
  end
end