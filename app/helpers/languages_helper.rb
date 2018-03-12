module LanguagesHelper
  # @param [Language] entity
  def language_name(entity)
    return t(:not_set) if entity.nil?

    t("languages.#{entity.slug}", default: entity.slug)
  end

  def languages_for_select
    options = [[t(:not_set), '']]
    Language.ordered_by_priority.each do |language|
      options << ["#{language.code}: #{language_name(language)}", language.id]
    end
    options
  end
end
