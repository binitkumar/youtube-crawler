class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :title
      t.string :youtube_id
      t.string :channel_image_url
      t.string :category
      t.integer :subscriber_count
      t.integer :videos_count
      t.datetime :joinned_on
      t.string :latest_video_title
      t.string :latest_video_link
      t.string :latest_video_id

      t.timestamps
    end
  end
end
