module CodesHelper
  def code_categories_for_select
    Code.categories.keys.map { |category| [t("activerecord.attributes.code.categories.#{category}"), category] }
  end
end