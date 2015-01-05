module ApplicationHelper
  def  translate_category(code)
    Categories.find_by_code(code).name
  end
end
