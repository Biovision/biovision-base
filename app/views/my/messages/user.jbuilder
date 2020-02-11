json.data @collection do |entity|
  json.partial! 'my/messages/message', entity: entity
end
json.partial! 'shared/pagination', collection: @collection
