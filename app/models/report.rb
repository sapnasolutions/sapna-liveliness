require 'pivotal_tracker/project'

class Report
    
  attr_reader :params, :session
  
  def initialize(params = {}, session = {})
    @params = params
    @session = session
    @errors = []
    validate
  end
  
  def generate
    (start_date, end_date) = check_date_interval
    project = get_project
    members = get_members(project)
    activities = get_activities(start_date, end_date, project)
    filtered_activities = filter_activities(activities, members)
  end
  
  def errors
    @errors
  end
  
  def valid?
    @errors.blank?
  end
  
  #######
  private
  #######
  
  def validate
    add_errors("Login can't be blank.") if @session.blank? || @session[:pivotal_tracker_username].blank?
    add_errors("API Token can't be blank.") if @session.blank? || @session[:pivotal_tracker_token].blank?
    add_errors("Project can't be blank.") if @session.blank? || @session[:pivotal_tracker_project_id].blank?
    add_errors("Please select a valid date range for the report.") if @params[:report].blank? || (@params[:report].present? && (@params[:report][:from].blank? || @params[:report][:to].blank?)) 
  end
  
  def add_errors(error)
    @errors << error
    @errors.flatten!
  end
  
  def check_date_interval
    start_date  = get_date_from_string(@params[:report][:from])
    end_date    = get_date_from_string(@params[:report][:to])
    return [start_date, end_date]
  end
  
  def get_project
    project = PivotalTracker::Project.find_for_id(@session[:pivotal_tracker_token], @session[:pivotal_tracker_project_id])
    return project
  end
  
  def get_members(project)
    members = project.memberships.select{|x| @params[:pivotal_tracker][:users].include?(x.id.to_s)}
    return members
  end
  
  def get_activity_for(project, date)
    project.activities(date)
  end

  def get_activities(start_date, end_date, project)
    activities = []
    start_date.to_date.upto(end_date.to_date) do |date| 
      activities << get_activity_for(project, date)
      activities.flatten!
      activities.uniq!
    end
    return activities
  end
  
  def filter_activities(list, members)
    member_names = members.collect(&:name)
    return list.select{|x| member_names.include?(x.author)}
  end
  
  def get_date_from_string(date)
    month, day, year = date.split("-")
    Date.parse("#{year}/#{month}/#{day}")
  end
  
end