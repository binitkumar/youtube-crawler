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
      channels = channels.order( "#{params[:order]} desc " ) if params[:order]
      channels = channels.where(country: query.country) unless query.country == ""
      channels = channels.where(" subscriber_count < ?", query.min_subscriber_count) unless query.min_subscriber_count.nil?
      channels = channels.where(" subscriber_count > ?", query.max_subscriber_count) unless query.max_subscriber_count.nil?
      channels = channels.where(" videos_count > ?", query.min_total_videos) unless query.min_total_videos.nil?
      channels = channels.where(" latest_video_published_at > ?", query.last_video_published.to_i.days.ago) unless query.last_video_published.nil?
  
      puts channels.inspect
      puts query.inspect      
      if query.name
        @channels = channels.search(query.name)
      else
        @channels = channels
      end
  end
end
