require 'pivotal_tracker/base'

module PivotalTracker
  class Project < PivotalTracker::Base  
    self.site = PivotalTracker::BASE_REST_URL
  
    def self.all(token)
      raise NoTokenException.new unless token
      headers['X-TrackerToken'] = token
      
      find(:all)
    end
    
    def self.find_for_id(token, id)
      raise NoTokenException.new unless token
      headers['X-TrackerToken'] = token
      
      find(id)
    end

    # we don't need to set the token here since it's been set at the Project.all level (see Base class)
    def memberships
      base_find(PivotalTracker::Membership, :all)
    end
    
    def activities(occurred_since_date = Time.now)
      options = {:project_id => self.id, :limit => 100, :occurred_since_date => occurred_since_date}
      base_find(PivotalTracker::Activity, :all, options)
    end

  private
    def params
      return { :project_id => self.id }
    end
  
    def map_items(items)
      items.map{ |x| x.project_id = self.id }
      return items
    end
      
  end
end