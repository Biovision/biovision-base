if collection.respond_to?(:current_page)
  json.links do
    json.self url_for(page: collection.current_page)
    unless collection.next_page.nil?
      json.next url_for(page: collection.next_page)
    end
    json.last url_for(page: collection.total_pages)
  end
end
