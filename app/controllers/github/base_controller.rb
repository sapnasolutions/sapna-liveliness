class Github::BaseController < ApplicationController
  helper_method :load_repositories
  
  #######
  private
  #######
  
  def load_repositories(credentials)
    @repositories = Github::Repository.all(credentials[:login], credentials[:password])
    return @repositories
  end
  
  def load_repository
    if session[:github_credentials] and params[:repository_name]      
      @repository = (repositories = load_repositories(session[:github_credentials])).select{|x| x.name == params[:repository_name]}.first
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
  
end