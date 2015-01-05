class AddCountryToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :country, :string
  end
end
