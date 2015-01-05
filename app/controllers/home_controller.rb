class HomeController < ApplicationController
  def index
    @countries = Countary.all
    @categories = Categories.all
  end

  def search
    query = Query.create(
      name: params[:name],
      category: params[:category_id],
      country: params[:country_id],
      min_subscriber_count: params[:min_subs], 
      max_subscriber_count: params[:max_subs],
      min_total_views: params[:min_views], 
      max_total_views: params[:max_views], 
      min_total_videos: params[:videos],
      last_video_published: params[:last_video_date], 
      keywords: params[:tags]  
    )
    redirect_to "/home/results?id=#{query.id}"
  end

  def results
      query = Query.find params[:id]
      channels = Channel.all
      channels = channels.order( "#{params[:order]} " ) if params[:order]
      channels = channels.where(country: query.country) unless query.country == ""
      channels = channels.where(category: query.category) unless query.category == ""
      channels = channels.where(" subscriber_count > ?", query.min_subscriber_count) unless query.min_subscriber_count.nil?
      channels = channels.where(" subscriber_count < ?", query.max_subscriber_count) unless query.max_subscriber_count.nil?
      channels = channels.where(" videos_count > ?", query.min_total_videos) unless query.min_total_videos.nil?
      channels = channels.where(" view_count > ?", query.min_total_views) unless query.min_total_views.blank?
      channels = channels.where(" view_count < ?", query.max_total_views) unless query.max_total_views.blank?
      channels = channels.where(" latest_video_published_at > ?", query.last_video_published.to_i.days.ago) unless query.last_video_published.nil?
  
      puts channels.inspect
      puts query.inspect      
      if query.name
        @channels = channels.search(query.name).paginate(:page => params[:page])
      else
        @channels = channels.paginate(:page => params[:page])
      end
  end

  def export
      query = Query.find params[:id]
      channels = Channel.all
      channels = channels.order( "#{params[:order]} desc " ) if params[:order]
      channels = channels.where(country: query.country) unless query.country == ""
      channels = channels.where(category: query.category) unless query.category == ""
      channels = channels.where(" subscriber_count > ?", query.min_subscriber_count) unless query.min_subscriber_count.nil?
      channels = channels.where(" subscriber_count < ?", query.max_subscriber_count) unless query.max_subscriber_count.nil?
      channels = channels.where(" videos_count > ?", query.min_total_videos) unless query.min_total_videos.nil?
      channels = channels.where(" view_count > ?", query.min_total_views) unless query.min_total_views.blank?
      channels = channels.where(" view_count < ?", query.max_total_views) unless query.max_total_views.blank?
      channels = channels.where(" latest_video_published_at > ?", query.last_video_published.to_i.days.ago) unless query.last_video_published.nil?
  
      puts channels.inspect
      puts query.inspect      
      if query.name
        @channels = channels.search(query.name)
      else
        @channels = channels
      end
     
      p = Axlsx::Package.new

      p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row ["Name", "Youtue ID", "Country", "Subscriber Count", "Video count", "Joined on", "Latest video title", "Latest video published at"]
        @channels.each do |ch| 
          sheet.add_row [ch.title, ch.youtube_id, ch.country, ch.subscriber_count, ch.videos_count, ch.joinned_on, ch.latest_video_title, ch.latest_video_published_at]
        end
      end
      p.use_shared_strings = true
      p.serialize('public/results.xlsx')

      send_file 'public/results.xlsx', :type=>"application/xlsx", :x_sendfile=>true
  end
end
