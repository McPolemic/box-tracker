class BoxGroup < ApplicationRecord
  has_many :box_group_images, dependent: :destroy
  has_many :images, through: :box_group_images

  has_many :box_group_boxes, dependent: :destroy
  has_many :boxes, through: :box_group_boxes
end