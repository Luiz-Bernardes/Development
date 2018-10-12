# gemfile
gem "paperclip"

# THIS - generate model
rails g model image company:references description:text photo_file_name photo_content_type photo_file_size:integer photo_updated_at:datetime

#OR

# THIS - to add photo_file_name, photo_content_type, photo_file_size, photo_updated_at
rails g migration add_photo_to_images

class AddPhotoToImages < ActiveRecord::Migration[5.0]
  def up
    add_attachment :images, :photo
  end

  def down
    remove_attachment :images, :photo
  end
end


# image model
has_attached_file :photo
validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

# routes
resources :images


# image controller
class ImagesController < ApplicationController

  def create
    @image = Image.create( image_params )
  end

  private

  def image_params
    params.require(:image).permit(:photo, :company_id, :description)
  end

end

# view
.owl-carousel.owl-theme
  - @images.each_with_index do |image, index|
    div
      = image_tag image.image.url