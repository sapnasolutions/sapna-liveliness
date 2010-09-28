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
        page.replace_html "github-content", render(:partial => "github/repositories", :locals => { :repositories => load_repositories(params[:github]) })
        page.replace_html "github_menu", :partial => "github/menu"
      rescue Exception => e
        logger.error e.message
        flash.now[:error] = "Github: Incorrect username or API Token."
        page.replace_html(:messages, :partial => "/layouts/messages")
      end
    end
  end
  
  def destroy
    session[:github_credentials] = nil
    render :update do |page|
      page.replace_html "github_menu", :partial => "github/menu"
      page.replace_html "messages", :partial => "/layouts/messages"
      page.replace_html("github-content", "")
    end
  end

end
