class PivotalTracker::MembersController < PivotalTracker::BaseController
  
  before_filter :load_project
  
  def index    
    session[:pivotal_tracker_project_id] = @project.id
    session[:pivotal_tracker_project_name] = @project.name
    session[:pivotal_tracker_member_id] = nil
    @members = @project.memberships
    render :update do |page|
      page.replace_html("pivotal-content", render(:partial => "/pivotal_tracker/members/members"))
      page.replace("pivotal_tracker_menu", render(:partial => "/pivotal_tracker/menu"))
      page.replace_html "merged_report", get_merged_report_button
      page.call("createPickers")
    end
  end
end