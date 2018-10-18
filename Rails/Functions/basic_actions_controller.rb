# class ModelController < ApplicationController

before_action :set_model, only: [:edit, :update, :destroy]

# List all
Model.all
# Create empty object
Model.new
# Find object ex:params[:id]
Model.find(id)
# Save object
@object.save
# Update object
@object.update(params_require)
# Destroy object
@object.destroy(id)

#redirect to path
redirect_to
#render
render :new
#flash success/error
flash[:message]

# Set functions
private
  def set_model
    @model = Model.find(id)
  end

  def params_require
    params.require(:model).permit(:name, :email, :etc)
  end