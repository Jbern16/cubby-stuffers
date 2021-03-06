class Item < ApplicationRecord
  has_many :package_items
  has_many :packages, through: :package_items

  validates :name, uniqueness: true
end
