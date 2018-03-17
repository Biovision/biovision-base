json.data do
  json.id @user.id
  json.type @user.class.table_name
  json.attributes do
    json.(@user, :screen_name, :email)
  end
end
json.links do
  json.return_path @return_path
end
