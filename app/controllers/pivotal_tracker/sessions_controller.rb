require 'pivotal_tracker/token'

class PivotalTracker::SessionsController < PivotalTracker::BaseController

  def new
    render :update do |page|
      page.replace_html("pivotal-content", :partial => "new")
    end
  end
  
  def create
    @token = get_token(params[:pivotal_tracker])
    @projects = load_projects(@token) if @token
    render :update do |page|    
      if @token.present?
        session[:pivotal_tracker_token] = @token
        session[:pivotal_tracker_username] = params[:pivotal_tracker][:login]
        page.replace_html("pivotal-content", :partial => "pivotal_tracker/projects/projects")
      else
        flash.now[:error] = "Pivotal Tracker could not authenticate you with the credentials provided. Please try again."
      end
      page.replace "pivotal_tracker_menu", :partial => "pivotal_tracker/menu"
      page.replace_html "messages", :partial => "/layouts/messages"
    end
  end
  
  def destroy
    session[:pivotal_tracker_token], session[:pivotal_tracker_username] = nil
    render :update do |page|
      page.replace "pivotal_tracker_menu", :partial => "pivotal_tracker/menu"
      page.replace_html "messages", :partial => "/layouts/messages"
      page.replace_html("pivotal-content", "")
    end
    
  end
  
end