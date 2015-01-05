class AddLatestVideoPublishedAtToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :latest_video_published_at, :datetime
  end
end
