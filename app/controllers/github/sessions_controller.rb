class Github::SessionsController < Github::BaseController
  
  def new
    render :update do |page|
      page.replace_html("github-content", :partial => "new")
    end
  end
  
  def create
    session[:github_credentials] = params[:github]
    render :update do |page|
      begin
        render :partial => "github/repositories", :locals => { :repositories => load_repositories(params[:github]) }
      rescue
        flash.now[:error] = "Github: Incorrect username or API Token."
        page.replace_html(:messages, :partial => "/layouts/messages")
      end
    end
  end
  
  def destroy
  end

end
