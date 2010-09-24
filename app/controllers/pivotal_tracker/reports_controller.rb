require 'pivotal_tracker/token'

class PivotalTracker::ReportsController < PivotalTracker::BaseController
  before_filter :load_project
  
  def new
    render :update do |page|
      page.replace_html("pivotal-content", :partial => "new")
      page.call("createPickers")
    end
  end
  
  def create
    report = Report.new(params, session)
    @activities = report.generate
    @member_id  = params[:pivotal_tracker_member_id]
    render :update do |page|
      page.replace_html("pivotal-content", render(:partial => "pivotal_tracker/reports/activities"))
    end
  end
  
end