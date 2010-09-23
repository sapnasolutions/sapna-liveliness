require 'pivotal_tracker/project'

class PivotalTracker::BaseController < ApplicationController
  helper_method :load_projects
  
  #######
  private
  #######
  
  def load_projects(token)
    PivotalTracker::Project.all(token)
  end  
  
  def load_project
    if session[:pivotal_tracker_token] and params[:project_id]
      @projects = PivotalTracker::Project.all(session[:pivotal_tracker_token]) 
      @project = @projects.select{|x| x.id == params[:project_id]}.first
    end
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