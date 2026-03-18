class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a senior product manager.\n\nI am a junior product manager learning about understanding user needs.\n\nHelp me by summarizing the posts you find on social media.\n\nAnswer clearly."
  def new
    @message = Message.new
  end

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @product = @chat.product

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @chat.messages.create(role: "assistant", content: response.content)
      @chat.generate_title_from_first_message
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def product_context
    "Here is the context of the product: name : #{@product.name}, brand: #{@product.brand}"
  end

  def instructions
    [SYSTEM_PROMPT, product_context].compact.join("\n\n")
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
