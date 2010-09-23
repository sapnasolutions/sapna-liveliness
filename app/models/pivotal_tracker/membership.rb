require 'pivotal_tracker/base'

module PivotalTracker
  class Membership < PivotalTracker::Base  
    attr_accessor :project_id
  
    self.site = PivotalTracker::BASE_REST_URL + "/projects/:project_id"  
    
    def name
      self.attributes["person"].attributes["name"]
    end
  end
end