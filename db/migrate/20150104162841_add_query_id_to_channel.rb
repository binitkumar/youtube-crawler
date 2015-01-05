class AddQueryIdToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :query_id, :integer
  end
end
