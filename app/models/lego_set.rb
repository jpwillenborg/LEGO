class LegoSet < ApplicationRecord
  # Establish relationship bridges
  has_many :inventory_parts, dependent: :destroy
  has_many :parts, through: :inventory_parts

  # Ensure data integrity before saving to the database
  validates :set_num, presence: true, uniqueness: true
  validates :name, presence: true
end
