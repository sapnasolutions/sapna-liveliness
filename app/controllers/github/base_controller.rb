class Github::BaseController < ApplicationController
  helper_method :load_repositories, :load_collaborators
  
  
  #######
  private
  #######
  
  def load_repositories(credentials)
    @repositories = Github::Repository.all(credentials[:login], credentials[:password])
    return @repositories
  end
  
  def load_repository
    if session[:github_credentials] and params[:id]      
      @repository = (repositories = load_repositories(session[:github_credentials])).select{|x| x.name == params[:id]}.first
      return @repository
    end
  end
  
  def load_collaborators(repository)
    if session[:github_credentials] and repository
      @collaborators = repository.collaborators
      return @collaborators
    end
  end
  
  def load_collaborator
    if @repository and params[:collaborator_name]
      @collaborator = @repository.collaborators.select{|x| x.name == params[:collaborator_name]}.first
    end
  end
  
  def login_required?
    unless session[:github_credentials]
      flash.now[:error] = "Please login again! No credentials found!"
      render :update do |page|
        page.replace_html(:messages, :partial => "/layouts/messages")
      end
    end
  end
  
  def unless_repository?
    unless params[:id]
      flash.now[:error] = "No repositories found!"
      render :update do |page|
        page.replace_html(:messages, :partial => "/layouts/messages")
      end
    end
  end
  
end