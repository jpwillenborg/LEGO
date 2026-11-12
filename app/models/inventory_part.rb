class InventoryPart < ApplicationRecord
  belongs_to :lego_set
  belongs_to :part

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :loose_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
