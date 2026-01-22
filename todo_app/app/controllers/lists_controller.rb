class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board
  before_action :set_list, only: %i[update destroy]

  def create
    @list = @board.lists.new(list_params)

    if @list.save
      redirect_to @board, notice: "Lista criada com sucesso."
    else
      redirect_to @board, alert: @list.errors.full_messages.to_sentence
    end
  end

  def update
    if @list.update(list_params)
      redirect_to @board, notice: "Lista atualizada com sucesso."
    else
      redirect_to @board, alert: @list.errors.full_messages.to_sentence
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
