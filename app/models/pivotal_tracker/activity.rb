#require 'pivotal_tracker/base'

module PivotalTracker
  class Activity #< PivotalTracker::Base  
    attr_accessor :project_id, :author, :title, :activity_type, :occurred_at
  
    def initialize(author, occurred_at, title, activity_type, project_id = nil)
      @project_id, @author, @title, @activity_type, @occurred_at = project_id, author, title, activity_type, occurred_at
    end
    
  end
end