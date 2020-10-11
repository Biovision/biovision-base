module CodesHelper
  def code_types_for_select
    CodeType.order('id asc').map { |c| [c.name, c.id] }
  end
end
