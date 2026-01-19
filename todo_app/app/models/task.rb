class Task < ApplicationRecord
  belongs_to :list

  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true
end
