# create migration
class CreateSponsorshipsKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :sponsorships_kinds do |t|
      t.integer :sponsorship_id
      t.integer :kind_id
    end
  end
end

# class sponsorship
class Sponsorship < ApplicationRecord
  has_many :sponsorships_kinds
  has_many :kinds, through: :sponsorships_kinds
end

# class kind
class Kind < ApplicationRecord
  has_many :sponsorships_kinds
  has_many :sponsorships, through: :sponsorships_kinds
end

# class sponsorshipskind
class SponsorshipsKind < ApplicationRecord
  belongs_to :kind
  belongs_to :sponsorship
end

# controller sponsorship
private
  def sponsorship_params
    params.require(:sponsorship).permit(:date, :event, kind_ids:[])
  end

# view
= f.collection_check_boxes(:kind_ids, Kind.all, :id, :name)
