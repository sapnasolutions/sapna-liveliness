require 'pivotal_tracker/project'

class PivotalTracker::BaseController < ApplicationController
  helper_method :load_projects
  
  #######
  private
  #######
  
  def load_projects(token)
    PivotalTracker::Project.all(token)
  end
  
  def load_member
    if @project and params[:member_id]
      @member = @project.memberships.select{|x| x.id == params[:member_id]}.first
    end
  end
  
  def get_token(params)
    PivotalTracker::Token.get_token(params[:login], params[:password])
  end
  
end