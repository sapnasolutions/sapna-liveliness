class Github::ReportsController < Github::BaseController
  before_filter :login_required?
  before_filter :unless_repository?
  before_filter :load_repository
  
  def create
    @commits = @repository.generate_report(params)
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html("github-content", render(:partial => "github/reports/commits"))
          # page.insert_html(:top, "github-content", 
          #                       content_tag(:div, :class => "right", :id => "github_export_report") do 
          #                         button_to("Export to XLS", {:controller => "github/reports", :action => :create, :format => "xls", :params => params}, :method => :post, :disable_with => "Please wait...") 
          #                       end
          #                     )
          #           page.insert_html(:after, "github_export_report", content_tag(:div, '', :class => "clear"))
        end
      end
      format.xls do
        headers['Content-Type'] = "application/vnd.ms-excel"
        headers['Content-Disposition'] = 'attachment; filename="sapna_liveliness_github_commits_for_' + @repository.name + '_' + Time.now.strftime("%Y-%m-%d_%H:%M:%S").to_s + '.xls"'
        headers['Cache-Control'] = ''
        render :partial => "/github/reports/commits"
      end
    end
  end
  
end