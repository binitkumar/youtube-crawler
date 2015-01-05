class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :name
      t.string :category
      t.string :country
      t.integer :min_subscriber_count
      t.integer :max_subscriber_count
      t.string :min_total_views
      t.string :max_total_views
      t.integer :min_total_videos
      t.datetime :last_video_published
      t.string :keywords

      t.timestamps
    end
  end
end
