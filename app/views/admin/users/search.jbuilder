json.data do
  if @collection.any?
    json.users @collection do |user|
      json.(user, :id, :slug, :email)
      json.surname user.profile_data['surname']
      json.name user.profile_data['name']
    end
  else
    json.users []
  end
  json.html render(partial: 'admin/users/search/results', formats: [:html], locals: { collection: @collection })
end
