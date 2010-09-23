require 'pivotal_tracker/base'

module PivotalTracker
  class Activity < PivotalTracker::Base  
    attr_accessor :project_id
  
    self.site = PivotalTracker::BASE_REST_URL + "/projects/:project_id"  
    
    def type
      attributes["event_type"]      
    end
    
    def author
      attributes["author"]
    end
    
  end
end