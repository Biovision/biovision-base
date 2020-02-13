json.data @collection do |entity|
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.call(entity, :created_at, :data, :read)
  end
  notifier = Biovision::Notifiers::BaseNotifier[entity]
  view_name = notifier.view
  json.meta do
    unless view_name.nil?
      json.html render(partial: view_name, formats: [:html], locals: { notification: entity, entity: notifier.entity })
    end
    json.component entity.biovision_component.slug
    json.time_ago time_ago_in_words(entity.created_at)
  end
  json.links do
    json.self my_notification_path(id: entity.id)
    json.read read_my_notification_path(id: entity.id)
  end
end
json.links do
  json.self my_notifications_path
end
