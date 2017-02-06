class Item < ApplicationRecord
  has_many :articles
  belongs_to :cart
end
