json.data @collection do |entity|
  json.partial! 'image', locals: { entity: entity }
end
json.partial! 'shared/pagination', locals: { collection: @collection }
