require 'github/repository'

class Github::UsersController < Github::BaseController

  def login
    raise NoLoginFoundException.new unless params[:github]
    session[:github_credentials] = params[:github]
    render :partial => "github/repositories", :locals => { :repositories => load_repositories(params[:github]) }, :layout => false
  rescue NoLoginFoundException
    render_json_error("please login again", "no login information found")
  rescue Octopussy::NotFound
    render_json_error("please login again", "no repositories found")
  rescue Octopussy::Unauthorized
    render_json_error("please login again", "no login information found")
  end
  
end