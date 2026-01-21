class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board
  before_action :set_list, only: %i[show edit update destroy]

  def index
    @lists = @board.lists
  end

  def show
  end

  def new
    @list = @board.lists.new
  end

  def create
    @list = @board.lists.new(list_params)

    if @list.save
      redirect_to @board, notice: "Lista criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @list.update(list_params)
      redirect_to @board, notice: "Lista atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    redirect_to @board, notice: "Lista excluída com sucesso."
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  def set_list
    @list = @board.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:title)
  end
end
