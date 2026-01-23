class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board
  before_action :set_list
  before_action :set_task, only: %i[update destroy]

  def create
    @task = @list.tasks.new(task_params)

    if @task.save
      sync_calendar_for(@task)
      redirect_back fallback_location: board_path(@board), notice: "Tarefa criada com sucesso."
    else
      redirect_back fallback_location: board_path(@board), alert: @task.errors.full_messages.to_sentence
    end
  end

  def update
    if @task.update(task_params)
      sync_calendar_for(@task)
      redirect_back fallback_location: board_path(@board), notice: "Tarefa atualizada com sucesso."
    else
      redirect_back fallback_location: board_path(@board), alert: @task.errors.full_messages.to_sentence
    end
  end

  def destroy
    sync_calendar_for(@task, deleting: true)
    @task.destroy
    redirect_back fallback_location: board_path(@board), notice: "Tarefa excluída com sucesso."
  end

  private

  def sync_calendar_for(task, deleting: false)
    service = GoogleCalendarService.new(current_user)

    if deleting
      service.delete_event_for_task(task)
      return
    end

    if task.due_date.present?
      service.create_or_update_event_for_task(task)
    else
      service.delete_event_for_task(task)
    end
  rescue => e
    Rails.logger.error("[GoogleCalendar] sync falhou: #{e.class} #{e.message}")
  end

  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  def set_list
    @list = @board.lists.find(params[:list_id])
  end

  def set_task
    @task = @list.tasks.find(params[:id])
  end

  def task_params
    permitted = params.require(:task).permit(:title, :description, :status, :priority, :due_date)

    if permitted[:due_date].present?
      permitted[:due_date] = Time.zone.parse(permitted[:due_date])
    end

    permitted
  end
end
