namespace :loader do
  task :load_channels => :environment do
    Countary.all.each do |cntry|
      search_response = CLIENT.execute!(
        :api_method => YOUTUBE.search.list,
        :parameters => {
          :part => 'id, snippet',
          :maxResults => 50,
          :type => 'channel',
          :regionCode=> cntry.code,            
        }
      )
      
      @data = JSON.parse(search_response.response.body)
      @channels = @data["items"]
      channel_ids = @channels.collect{|x| { channelId: x["id"]["channelId"], 
          publishedAt: x["snippet"]["publishedAt"], 
          title: x["snippet"]["title"], 
          description: x["snippet"]["description"],
          image: x["snippet"]["thumbnails"]["default"]
        } 
      }
      
      channels_ids_collection = channel_ids.collect{|x| x[:channelId] }.uniq
      puts channels_ids_collection.join(", ")
      channel_details = CLIENT.execute!(
        :api_method => YOUTUBE.channels.list,
        :parameters => {
          :part => 'id, snippet, statistics',
          :id => channels_ids_collection.join(", ")
        }
      )   
      
      channel_data = JSON.parse(channel_details.response.body)["items"]
      
      until @data["nextPageToken"] == nil do
        begin
          search_response = CLIENT.execute!(
            :api_method => YOUTUBE.search.list,
            :parameters => {
              :part => 'id, snippet',
              :maxResults => 50,
              :type => 'channel',
              :regionCode=> cntry.code,            
              :pageToken=> @data["nextPageToken"]
            }
          )
      
          @data = JSON.parse(search_response.response.body)
          @channels = @data["items"]
      
          channel_ids = @channels.collect{|x| { 
              channelId: x["id"]["channelId"] 
            } 
          }
          channels_ids_collection = channel_ids.collect{|x| x[:channelId] }.uniq
          puts channels_ids_collection.join(", ")
          begin
          channel_details = CLIENT.execute!(
            :api_method => YOUTUBE.channels.list,
            :parameters => {
              :part => 'id, snippet, statistics',
              :id => channels_ids_collection.join(",")
            }
          )   
          
          channel_data += JSON.parse(channel_details.response.body)["items"]
          rescue => exp
            puts channels_ids_collection.join(", ").inspect
            puts exp.message
          end
        rescue => exp
          puts exp.message
          @data["nextPageToken"] = nil
        end
      end
      
      channel_data.each do |x|
        begin
          existing_channel = Channel.find_by_youtube_id(x["id"])
          
          unless existing_channel
            video_results = CLIENT.execute!(
              :api_method => YOUTUBE.search.list,
              :parameters => {
                :part => 'id, snippet',
                :channelId => x["id"],
                :maxResults => 5,
                :order => "date",
                :type => 'video',
                :publishedAfter => DateTime.parse(60.days.ago.to_datetime.rfc3339(9))
              }
            )
      
            video_data = JSON.parse(video_results.response.body)
            latest_video = video_data["items"].first
      
            if latest_video && latest_video["snippet"]["publishedAt"] && 60.days.ago < DateTime.parse(latest_video["snippet"]["publishedAt"])              
              channel = Channel.create(youtube_id: x["id"])
              puts "Loading channel #{x["id"]}"
              channel.update_attributes(
                country: cntry.code, 
                title: x["snippet"]["title"], 
                description: x["snippet"]["description"],
                channel_image_url: x["snippet"]["thumbnails"]["default"]["url"],
                subscriber_count: x["statistics"]["subscriberCount"],
                videos_count: x["statistics"]["videoCount"],
                view_count: x["statistics"]["viewCount"],
                joinned_on: DateTime.parse(x["snippet"]["publishedAt"]),       
                latest_video_title: latest_video["snippet"]["title"], 
                latest_video_link: "https://www.youtube.com/watch?v=#{latest_video["id"]["videoId"]}", 
                latest_video_id: latest_video["id"]["videoId"],
                latest_video_published_at: latest_video["snippet"]["publishedAt"]
              )
            end
          end
        rescue => exp
          puts exp.message
        end
      end 
    end 
  end
end
