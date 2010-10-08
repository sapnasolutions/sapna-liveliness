# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def indicator(options = {})
    options = {:size => :small}.merge(options)
    render :partial => "/shared/indicator", :locals => { :options => options }
  end
  
  def get_merged_report_button
    if (params[:controller].present? && params[:controller] == "merged_report") || (session[:github_repository_name].present? && session[:pivotal_tracker_project_id].present?)
      link_to "Merged report", new_merged_report_path
    end
  end
  
end
