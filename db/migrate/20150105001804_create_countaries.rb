class CreateCountaries < ActiveRecord::Migration
  def change
    create_table :countaries do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
