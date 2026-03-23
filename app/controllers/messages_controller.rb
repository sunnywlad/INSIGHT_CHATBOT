class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a senior consumer insights analyst.

    Your job is to analyze real social media posts and extract actionable insights for product teams.

    When given social media data, you must:
    - Summarize the overall sentiment (positive, negative, mixed)
    - Identify key themes and recurring opinions
    - Highlight notable quotes or posts
    - Give a clear, concise answer to the user's question

    Answer in the same language as the user's question.
  PROMPT

    # Always base your analysis on the provided social media data. If no data is available, say so clearly.

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @product = @chat.product

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      # reddit_posts = scrape_reddit
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

  # def scrape_reddit
  #   query = "#{@product.name} #{@product.brand} #{@message.content}"
  #   RedditScraper.new(query).call
  # end

  # def format_reddit_data(posts)
  #   return "No social media data found for this query." if posts.empty?

  #   formatted = posts.map.with_index(1) do |post, i|
  #     text = post[:body].present? ? "\n   #{post[:body]}" : ""
  #     "#{i}. [r/#{post[:subreddit]}] #{post[:title]} (score: #{post[:score]}, #{post[:num_comments]} comments)#{text}"
  #   end

  #   "Here are #{posts.size} Reddit posts about #{@product.name} by #{@product.brand}:\n\n#{formatted.join("\n\n")}"
  # end

  def product_context
    "Product context: Name is #{@product.name} by brand : #{@product.brand}"
  end

  def instructions
    [SYSTEM_PROMPT, product_context].join("\n\n---\n\n")
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
