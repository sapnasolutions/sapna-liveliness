class Github::BaseController < ApplicationController
  
  
  #######
  private
  #######
  
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