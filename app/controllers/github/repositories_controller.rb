class Github::RepositoriesController < Github::BaseController
  
  before_filter :login_required?
  before_filter :unless_repository?, :only => :collaborators
  before_filter :load_repository, :only => :collaborators 
  
  def index
    session[:github_repository_name], session[:github_collaborator_name] = nil
    render :update do |page|
      page.replace_html "github-content", render(:partial => "github/repositories", :locals => { :repositories => load_repositories(session[:github_credentials]) })
    end
  end

  def collaborators
    if @repositories && @repository
      session[:github_repository_name], session[:github_collaborator_name] = @repository.name, nil
      render :update do |page|
        page.replace_html "github-content", render(:partial => '/github/collaborators', :locals => { :repository => @repository, :collaborators => load_collaborators(@repository) })
      end
    else
      flash.now[:error] = "No repositories found!"
      render :update do |page|
        page.replace_html(:messages, :partial => "/layouts/messages")
      end
    end
  end
  
  
  private
  
  def unless_repository?
    unless params[:id]
      flash.now[:error] = "No repositories found!"
      render :update do |page|
        page.replace_html(:messages, :partial => "/layouts/messages")
      end
    end
  end
  
end