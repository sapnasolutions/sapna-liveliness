class PivotalTracker::MembersController < PivotalTracker::BaseController
  
  before_filter :load_project
  
  def index    
    session[:pivotal_tracker_project_id] = @project.id
    session[:pivotal_tracker_member_id] = nil
    @members = @project.memberships
    render :update do |page|
      page.replace_html("pivotal-content", render(:partial => "/pivotal_tracker/members/members"))
    end
  end
end