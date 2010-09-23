require 'pivotal_tracker/token'

class PivotalTracker::SessionsController < PivotalTracker::BaseController

  def new
    render :update do |page|
      page.replace_html("pivotal-content", :partial => "new")
    end
  end
  
  def create
    token = get_token(params[:pivotal_tracker])
    render :update do |page|    
      if token.present?
        session[:pivotal_tracker_token] = token
        session[:pivotal_tracker_username] = params[:pivotal_tracker][:login] if token
        render :partial => "pivotal_tracker/projects", :locals => { :projects => load_projects(token) }, :layout => false
      else
      end
    end
  end
  
  def destroy
    session[:pivotal_tracker_token], session[:pivotal_tracker_username] = nil
    redirect_to root_path
  end
  
  private
  
  def get_token(params)
    x=PivotalTracker::Token.get_token(params[:login], params[:password])
    x
  end
  
end