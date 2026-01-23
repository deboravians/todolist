class Task < ApplicationRecord
  belongs_to :list

  after_commit :sync_google_calendar_event, on: %i[create update], if: :saved_change_to_due_date? 
  after_commit :delete_google_calendar_event, on: %i[destroy]

  enum :status, { pending: 0, in_progress: 1, completed: 2 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true

  before_save :sync_completed_at

  scope :pending_tasks, -> { where(status: statuses[:pending]) }
  scope :in_progress_tasks, -> { where(status: statuses[:in_progress]) }
  scope :completed_tasks, -> { where(status: statuses[:completed]) }

  scope :overdue, -> {
    where.not(due_date: nil)
      .where("DATE(due_date) < ?", Date.current)
      .where.not(status: statuses[:completed])
  }

  def sync_google_calendar_event
    user = list.board.user
    service = GoogleCalendarService.new(user)

    if due_date.blank?
      service.delete_event_for_task(self)
      update_column(:google_event_id, nil) if google_event_id.present?
    else
      service.create_or_update_event_for_task(self)
    end
  end

  def delete_google_calendar_event
    return unless list&.board&.user
    GoogleCalendarService.new(list.board.user).delete_event_for_task(self)
  end

  private

  def sync_completed_at
    if completed?
      self.completed_at ||= Time.current
    else
      self.completed_at = nil
    end
  end
end
