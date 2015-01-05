class Channel < ActiveRecord::Base
  belongs_to :query

  search_syntax do

    search_by :text do |scope, phrases|
      columns = [:title, :description]
      scope.where_like(columns => phrases)
    end

  end


end
