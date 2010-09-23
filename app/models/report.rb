require 'pivotal_tracker/project'

class Report
    
  attr_reader :params, :session
  
  def initialize(params, session)
    @params = params
    @session = session
  end
  
  def generate
    (start_date, end_date) = check_date_interval
    project = get_project
    member = get_member(project)
    activities = get_activities(start_date, end_date, project)
    filtered_activities = filter_activities(activities, member)
  end
  
  private
  
  def check_date_interval
    start_date  = get_date_from_string(@params[:report][:from])
    end_date    = get_date_from_string(@params[:report][:to])
    return [start_date, end_date]
  end
  
  def get_project
    project = PivotalTracker::Project.find_for_id(@session[:pivotal_tracker_token], @session[:pivotal_tracker_project_id])
    return project
  end
  
  def get_member(project)
    member = project.memberships.select{|x| x.id == @params[:pivotal_tracker_member_id]}.first
    return member
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
  
  def filter_activities(list, member)
    return list.select{|x| x.author == member.name}
  end
  
  def get_date_from_string(date)
    month, day, year = date.split("-")
    Date.parse("#{year}/#{month}/#{day}")
  end
  
end