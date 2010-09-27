class PivotalTracker::MembersController < PivotalTracker::BaseController
  
  before_filter :load_project
  
  def index    
    session[:pivotal_tracker_project_id] = @project.id
    session[:pivotal_tracker_project_name] = @project.name
    session[:pivotal_tracker_member_id] = nil
    @members = @project.memberships
    render :update do |page|
      page.replace_html("pivotal-content", render(:partial => "/pivotal_tracker/members/members"))
      page.replace_html("pivotal_tracker_menu", render(:partial => "/pivotal_tracker/menu"))
      page.call("createPickers")
    end
  end
end