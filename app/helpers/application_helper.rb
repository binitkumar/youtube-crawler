module ApplicationHelper
  def  translate_category(code)
    category = Categories.find_by_code(code)
    category ? category.name : ""
  end
end
