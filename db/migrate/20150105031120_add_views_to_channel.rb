class AddViewsToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :view_count, :integer
  end
end
