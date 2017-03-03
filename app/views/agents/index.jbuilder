json.data do
  json.agents @collection do |agent|
    json.partial! agent
  end
end
