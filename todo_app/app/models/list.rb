class List < ApplicationRecord
  belongs_to :board
  has_many :tasks, dependent: :destroy
  validates :title, presence: true
end
