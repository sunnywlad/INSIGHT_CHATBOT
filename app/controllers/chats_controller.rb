class ChatsController < ApplicationController
  def index
    @chats = current_user.chats.order(created_at: :desc)
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = current_user.chats.build(chat_params)
    if @chat.save
      redirect_to @chat
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
