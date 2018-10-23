if collection.respond_to?(:current_page)
  qp = request.query_parameters.merge(format: :json)

  json.links do
    json.self url_for(qp.merge(page: collection.current_page))
    json.first url_for(qp.merge(page: 1))
    unless collection.prev_page.nil?
      json.prev url_for(qp.merge(page: collection.prev_page))
    end
    unless collection.next_page.nil?
      json.next url_for(qp.merge(page: collection.next_page))
    end
    json.last url_for(qp.merge(page: collection.total_pages))
  end
end
