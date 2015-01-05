module ApplicationHelper
  def  translate_category(code)
    cateogory = Categories.find_by_code(code)
    category ? category.name : ""
  end
end
