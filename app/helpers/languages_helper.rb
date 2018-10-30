# frozen_string_literal: true

# Helper for language operations
module LanguagesHelper
  # @param [Language] entity
  def language_name(entity)
    return t(:not_set) if entity.nil?

    t("languages.#{entity.slug}", default: entity.slug)
  end

  # @param [Boolean] include_blank
  def languages_for_select(include_blank = true)
    options = []
    options << [t(:not_set), ''] if include_blank
    Language.active.ordered_by_priority.each do |language|
      options << ["#{language.code}: #{language_name(language)}", language.id]
    end
    options
  end
end
