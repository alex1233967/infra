class Phone < ActiveRecord::Base
  validates                 :name, presence: true, length: { maximum: 50 }

  validates_numericality_of :branch, greater_than_or_equal_to: 0, only_integer: true, length: { maximum: 2 }

  validates_format_of       :phone_number, :with => /\A(\d{12}|0)\z/
  validates_numericality_of :phone_number
end
