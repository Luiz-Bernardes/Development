# model user
has_many :phones
# model phone
belongs_to :user
# VIEW
= f.association :user