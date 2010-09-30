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
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html("pivotal-content", render(:partial => "pivotal_tracker/reports/activities"))
          page.insert_html(:top, "pivotal-content", 
            content_tag(:div, :class => "right", :id => "pivotal_export_report") do 
              button_to("Export to XLS", :controller => "/pivotal_tracker/reports", :method => :post, :format => "xls", :params => params.inspect, :disable_with => "Please wait...") 
            end
          )
          page.insert_html(:after, "pivotal_export_report", content_tag(:div, '', :class => "clear"))
        end
      end
      format.xls do
        headers['Content-Type'] = "application/vnd.ms-excel"
        headers['Content-Disposition'] = 'attachment; filename="sapna_liveliness_pivotal_tracker_activity_for_' + @project.name + '_' + Time.now.strftime("%Y-%m-%d_%H:%M:%S").to_s + '.xls"'
        headers['Cache-Control'] = ''
        render :partial => "/pivotal_tracker/reports/activities"
      end
    end
  end
  
end