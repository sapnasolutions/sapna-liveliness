class MergedReportsController < ApplicationController
  before_filter :remove_top_menu
  before_filter :require_login_in_both_tracker_and_github
  before_filter :require_projects_selected_for_both_tracker_and_github
  before_filter :load_project # Load Tracker project
  before_filter :load_repository #Load Github repo
  
  def new
    @no_submit = true
    @members = @project.memberships
    @collaborators = load_collaborators(@repository)
    @branches = @repository.client.branches("#{session[:github_credentials][:login]}/#{@repository.name}").keys
  end
  
  def create
    # Tracker report
    flash[:error] = []
    flash[:error] << "Report date can't be blank.<br/>" if !params[:report].present? || (params[:report][:from].blank? || params[:report][:to].blank?)
    flash[:error] << "Please select users.<br/>" if !params[:pivotal_tracker].present? || params[:pivotal_tracker][:users].blank? || params[:github][:users].blank?
    flash[:error] << "Please select github branch.<br/>" if !params[:github].present? || params[:github][:branches].blank?
    return(redirect_to :action => :new) if flash[:error].present?
    report = Report.new(params, session)
    activities = report.generate
    commits = @repository.generate_report(params)
    @activities = generate_activity_hash(activities + commits)
  end
  
  #######
  private
  #######
  
  def remove_top_menu
    @no_separate_divs = true
  end
  
  def require_login_in_both_tracker_and_github
    return true if check_tracker_sessions && check_github_sessions
    flash.now[:notice] = "Please login in github and tracker accounts."
    redirect_to root_path
  end
  
  def require_projects_selected_for_both_tracker_and_github
    return true if session[:github_repository_name].present? && session[:pivotal_tracker_project_id].present?
    flash.now[:notice] = "Please select github and tracker projects."
    redirect_to root_path
  end
  
  def check_tracker_sessions
    session[:pivotal_tracker_username].present? && 
    session[:pivotal_tracker_password].present? && 
    session[:pivotal_tracker_token].present?
  end
  
  def check_github_sessions
    session[:github_credentials].present?
  end
  
  def generate_activity_hash(activities)
    activities_hash = {}
    for activity in activities
      activities_hash = add_activity_in_hash_based_on_type(activities_hash, activity)
    end
    activities_hash
  end
  
  def add_activity_in_hash_based_on_type(activities_hash, activity)
    if activity.class.to_s == "PivotalTracker::Activity"
      key = activity.occurred_at.strftime("%d-%m-%Y")
    else
      key = Date.parse(activity.committed_date).strftime("%d-%m-%Y")
    end
    activities_hash = add_activity_to_hash(activities_hash, activity, key)
  end
  
  def add_activity_to_hash(activities_hash, activity, key)
    if activities_hash.keys.include?(key)
      activities_hash[key] << activity
    else
      activities_hash[key] = activity.to_a
    end
    activities_hash
  end

end
