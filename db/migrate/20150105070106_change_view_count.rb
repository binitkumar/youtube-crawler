class ChangeViewCount < ActiveRecord::Migration
  def change
    change_column :channels, :view_count, :bigint
  end
end
