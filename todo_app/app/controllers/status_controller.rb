class StatusController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.includes(list: :board).order(created_at: :desc)

    @overdue_tasks = tasks.overdue

    @pending_tasks = tasks.pending_tasks
                         .where("due_date IS NULL OR DATE(due_date) >= ?", Date.current)

    @in_progress_tasks = tasks.in_progress_tasks
                          .where("due_date IS NULL OR DATE(due_date) >= ?", Date.current)

    @completed_tasks = tasks.completed_tasks
  end
end
