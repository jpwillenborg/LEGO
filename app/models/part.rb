class Part < ApplicationRecord
  has_many :inventory_parts, dependent: :destroy
  has_many :lego_sets, through: :inventory_parts

  validates :part_num, presence: true, uniqueness: true
  validates :name, presence: true
end
