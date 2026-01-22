class Task < ApplicationRecord
  belongs_to :list

  enum :status, { pending: 0, in_progress: 1, completed: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true

  before_save :sync_completed_at

  scope :pending_tasks, -> { where(status: statuses[:pending]) }
  scope :in_progress_tasks, -> { where(status: statuses[:in_progress]) }
  scope :completed_tasks, -> { where(status: statuses[:completed]) }

  scope :overdue, -> {
    where.not(due_date: nil)
      .where("due_date < ?", Date.current)
      .where.not(status: statuses[:completed])
  }

  private

  def sync_completed_at
    if completed?
      self.completed_at ||= Time.current
    else
      self.completed_at = nil
    end
  end
end
