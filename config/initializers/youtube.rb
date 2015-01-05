require 'google/api_client'

DEVELOPER_KEY = 'AIzaSyA82Gg8TWg6I05NuDw8CzTgPmp6L5P3Bmk'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

CLIENT = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => "API Project",
    :application_version => '1.0.0'
  )
YOUTUBE = CLIENT.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
