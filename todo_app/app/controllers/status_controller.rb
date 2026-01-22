class StatusController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.includes(list: :board).order(created_at: :desc)

    @overdue_tasks = tasks.overdue

    @pending_tasks =
      tasks.pending
           .where("due_date IS NULL OR due_date >= ?", Date.current)

    @in_progress_tasks =
      tasks.in_progress
           .where("due_date IS NULL OR due_date >= ?", Date.current)

    @completed_tasks = tasks.completed
  end
end
