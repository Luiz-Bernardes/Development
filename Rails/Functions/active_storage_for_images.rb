$ rails active_storage:install
$ rails db:migrate

# config/storage.yml
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>

# config/environments/development.rb:
config.active_storage.service = :local

# models/post
class Post < ApplicationRecord
  has_one_attached :photo

  attribute :remove_photo, :boolean
  after_save -> { photo.purge }, if: :remove_photo
end

# gemfile
gem 'mini_magick'

# bundle


