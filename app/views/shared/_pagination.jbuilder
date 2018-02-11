if collection.respond_to?(:current_page)
  json.links do
    json.self url_for(page: collection.current_page, format: :json)
    json.first url_for(page: 1, format: :json)
    unless collection.prev_page.nil?
      json.prev url_for(page: collection.prev_page, format: :json)
    end
    unless collection.next_page.nil?
      json.next url_for(page: collection.next_page, format: :json)
    end
    json.last url_for(page: collection.total_pages, format: :json)
  end
end
