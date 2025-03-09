class Image < ApplicationRecord
  has_many :box_images, dependent: :destroy
  has_many :boxes, through: :box_images

  has_many :box_group_images, dependent: :destroy
  has_many :box_groups, through: :box_group_images
end