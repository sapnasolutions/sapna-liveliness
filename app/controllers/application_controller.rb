# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  # Tracker methods required in merged_report controller
  def load_project
    project_id = params[:project_id] || session[:pivotal_tracker_project_id]
    if session[:pivotal_tracker_token] and project_id
      @projects = PivotalTracker::Project.all(session[:pivotal_tracker_token]) 
      @project = @projects.select{|x| x.id == project_id}.first
    end
  end

  # Github methods required in merged_report controller
  helper_method :load_repositories, :load_collaborators
  
  def load_repository
    repo_id = params[:id] || session[:github_repository_name]
    if session[:github_credentials] and repo_id
      @repository = (repositories = load_repositories(session[:github_credentials])).select{|x| x.name == repo_id}.first
      return @repository
    end
  end
  
  def load_collaborators(repository)
    if session[:github_credentials] and repository
      @collaborators = repository.collaborators
      return @collaborators
    end
  end
  
  def load_repositories(credentials)
    @repositories = Github::Repository.all(credentials[:login], credentials[:password])
    return @repositories
  end
  
end
