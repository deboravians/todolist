class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board
  before_action :set_list
  before_action :set_task, only: %i[update destroy]

  def create
    @task = @list.tasks.new(task_params)

    if @task.save
      redirect_back fallback_location: board_path(@board), notice: "Tarefa criada com sucesso."
    else
      redirect_back fallback_location: board_path(@board),
                    alert: @task.errors.full_messages.to_sentence
    end
  end

  def update
    if @task.update(task_params)
      redirect_back fallback_location: board_path(@board), notice: "Tarefa atualizada com sucesso."
    else
      redirect_back fallback_location: board_path(@board),
                    alert: @task.errors.full_messages.to_sentence
    end
  end

  def destroy
    @task.destroy
    redirect_back fallback_location: board_path(@board), notice: "Tarefa excluída com sucesso."
  end

  private

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
    params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end
end
