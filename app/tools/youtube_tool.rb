class YoutubeTool < RubyLLM::Tool
  description "Search Youtube videos associated with a product and fetches users' comments to gather opinions."
  param :name, desc: "Then name of the product to search for on Youtube", type: :string
  param :brand, desc: "The brand of the product to search for on Youtube", type: :string

  def execute(name:, brand:)
    scraper = YoutubeScraperService.new(name: name, brand: brand)
    scraper.call(3)

    data.to_json
  rescue StandardError => e
    { error: "Failed to fetch Youtube data: #{e.message}" }.to_json
  end
end
