class TasksController < ApplicationController
  before_action :set_board
  before_action :set_list
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = @list.tasks.order(created_at: :desc)
  end

  def show
  end

  def new
    @task = @list.tasks.new
  end

  def create
    @task = @list.tasks.new(task_params)

    if @task.save
      redirect_to [@board, @list, @task], notice: "Tarefa criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to [@board, @list, @task], notice: "Tarefa atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to board_list_tasks_path(@board, @list), notice: "Tarefa excluída com sucesso."
  end

  private

  def current_user
    User.find_by!(email: "dev@local")
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
    params.require(:task).permit(:title, :description)
  end
end
