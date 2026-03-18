class ChatsController < ApplicationController

  def new
    @chat = Chat.new
  end

  def create
    @product = Product.find(params[:product_id])

    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.product = @product
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @product.chats.where(user: current_user)
      render "products/show"
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

end
