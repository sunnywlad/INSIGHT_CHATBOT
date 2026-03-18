class RedditScraper
  REDDIT_SEARCH_URL = "https://www.reddit.com/search.json"
  MAX_POSTS = 15
  USER_AGENT = "InsightsBot/1.0"

  def initialize(query, limit: MAX_POSTS)
    @query = query
    @limit = limit
  end

  def call
    fetch_posts
  rescue StandardError => e
    Rails.logger.error("RedditScraper error: #{e.message}")
    []
  end

  private

  def fetch_posts
    uri = URI(REDDIT_SEARCH_URL)
    uri.query = URI.encode_www_form(
      q: @query,
      limit: @limit,
      sort: "relevance",
      t: "year"
    )

    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = USER_AGENT

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    return [] unless response.is_a?(Net::HTTPSuccess)

    parse_posts(JSON.parse(response.body))
  end

  def parse_posts(data)
    children = data.dig("data", "children") || []

    children.map do |child|
      post = child["data"]
      {
        title: post["title"],
        body: truncate_text(post["selftext"], 500),
        subreddit: post["subreddit"],
        score: post["score"],
        num_comments: post["num_comments"],
        url: "https://reddit.com#{post['permalink']}"
      }
    end
  end

  def truncate_text(text, max_length)
    return "" if text.nil? || text.empty?
    text.length > max_length ? "#{text[0...max_length]}..." : text
  end
end
