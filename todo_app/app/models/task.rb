class Task < ApplicationRecord
  belongs_to :list

  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
end
