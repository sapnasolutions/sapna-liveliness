class PivotalTracker::ProjectsController < PivotalTracker::BaseController
  
  before_filter :load_project

  def index
    token = session[:pivotal_tracker_token]
    session[:pivotal_tracker_project_id] = nil
    session[:pivotal_tracker_project_name] = nil
    session[:pivotal_tracker_member_id] = nil
    @projects = load_projects(token)
    render :update do |page|
      page.replace_html("pivotal-content", render(:partial => "pivotal_tracker/projects/projects"))
      page.replace("pivotal_tracker_menu", render(:partial => "/pivotal_tracker/menu"))
    end
  end  
end