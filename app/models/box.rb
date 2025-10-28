class Box < ApplicationRecord
  has_many :box_images, dependent: :destroy
  has_many :images, through: :box_images

  has_many :box_group_boxes, dependent: :destroy
  has_many :box_groups, through: :box_group_boxes
end
