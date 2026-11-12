class RebrickableService
  BASE_URL = "https://rebrickable.com/api/v3/lego/" # FIXED: Added trailing slash here

  def initialize
    # Securely retrieve your Rebrickable API token from the encrypted credentials vault
    @api_key = Rails.application.credentials.dig(:rebrickable, :api_key)
  end

  # Primary action method to look up a set and populate local caching tables
  def fetch_set(set_num)
    existing_set = LegoSet.find_by(set_num: set_num)
    return existing_set if existing_set

    # 1. Fetch high-level set metadata from Rebrickable
    set_data = make_request("sets/#{set_num}")
    return nil unless set_data

    lego_set = LegoSet.create!(
      set_num: set_num,
      name: set_data["name"],
      year: set_data["year"],
      total_parts: set_data["num_parts"],
      image_url: set_data["set_img_url"]
    )

    # 2. Fetch the entire inventory part manifest for this specific set
    fetch_set_inventory(lego_set)

    lego_set
  rescue => e
    Rails.logger.error "Rebrickable API Error: #{e.message}"
    nil
  end

  private

  def fetch_set_inventory(lego_set)
    page = 1
    loop do
      response = make_request("sets/#{lego_set.set_num}/parts", { page: page, page_size: 100 })
      break unless response && response["results"]

      response["results"].each do |item|
        part_data = item["part"]

        part = Part.find_or_create_by!(part_num: part_data["part_num"]) do |p|
          p.name = part_data["name"]
          p.category = part_data["category"] || "Unknown"
          p.image_url = part_data["part_img_url"] || item["element_img_url"]
        end

        InventoryPart.create!(
          lego_set: lego_set,
          part: part,
          quantity: item["quantity"],
          loose_count: 0
        )
      end

      break unless response["next"]
      page += 1
    end
  end

  # Standard Faraday HTTP request wrapper handling authorization headers safely
  def make_request(endpoint, params = {})
    # FIXED: Replaced backslash combo to handle endpoints naturally
    response = Faraday.get("#{BASE_URL}#{endpoint}/") do |req|
      req.headers["Authorization"] = "key #{@api_key}"
      req.headers["Accept"] = "application/json"
      req.params = params
    end

    return nil unless response.success?

    JSON.parse(response.body)
  end
end
