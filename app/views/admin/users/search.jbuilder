json.data do
  if @collection.any?
    json.users @collection do |user|
      json.(user, :id, :slug, :email)
      json.surname user.user_profile&.surname
      json.name user.user_profile&.name
    end
  else
    json.users []
  end
  json.html render(partial: 'admin/users/search/results', formats: [:html], locals: { collection: @collection })
end
