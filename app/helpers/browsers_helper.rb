module BrowsersHelper
  def browsers_for_select
    options = [[t(:not_set), '']]
    Browser.ordered_by_name.each { |browser| options << [browser.name, browser.id] }
    options
  end
end