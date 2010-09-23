require 'pivotal_tracker'
require 'uri'

module PivotalTracker
  class NoTokenException < Exception; end
  
  def self.date_to_param(date)
    # URI.escape(date.strftime("%Y/%m/%d 00:00:00 UTC"))
    return date
  end  
  
  class Base < ActiveResource::Base
    include PivotalTracker
  
    class << self
      # If headers are not defined in a given subclass, then obtain headers from the superclass.
      def headers
        if defined?(@headers)
          @headers
        elsif superclass != Object && superclass.headers
          superclass.headers
        else
          @headers ||= {}
        end
      end
    end
    
    # headers['X-TrackerToken'] = PIVOTAL_TRACKER_CONFIG[:api_token]  
  
    def params
      # TODO: override this
      {}
    end
  
    def map_item(items)
      # TODO: override this
      items
    end
  
  private
    def base_find(clazz, find_keyword, params_hash = {})
      return map_items(clazz.send("find", find_keyword, :params => params_hash == {} ? params : params_hash))
    end
  
  end
end