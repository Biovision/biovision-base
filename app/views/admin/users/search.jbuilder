json.data do
  if @collection.any?
    json.users @collection do |user|
      json.call(user, :id, :slug, :email)
      json.surname user.data.dig('profile', 'surname')
      json.name user.data.dig('profile', 'name')
    end
  else
    json.users []
  end
  json.html render(partial: 'admin/users/search/results', formats: [:html], locals: { collection: @collection })
end
