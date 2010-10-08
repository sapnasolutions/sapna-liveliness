require 'mechanize'
module ScrapePivotalTracker 
  
  def create_activity(ary, row, title)
    author = (ary[0..1]).join(" ")
    action = (ary - ary[0..1]).join(" ")
    action += "(#{title})"
    activity_type = ary[2]
    activity = PivotalTracker::Activity.new(author, Time.parse(row.search("td[@class='progress_command_date']/text()").to_s), action, activity_type)
    activity
  end
  
  def login_to_tracker(username = session[:pivotal_tracker_username], password = session[:pivotal_tracker_password])
    agent = Mechanize.new
    login_page = agent.get("http://www.pivotaltracker.com")
    form = login_page.forms.first
    form["credentials[username]"] = username
    form["credentials[password]"] = password
    my_page = form.submit
    return agent, my_page
  end
  
  def get_activities(from, to, project_id = "")
    # from = Date.parse(from)
    #     to = Date.parse(to)
    activities = []
    agent, my_page = login_to_tracker
    reports_page = agent.click(my_page.link_with(:text => /Reports/))
    reports_form = reports_page.forms.first
    for date in from..to
      activity = get_report_for(reports_form, date, project_id)
      activities << activity
    end
    activities.flatten!
  end
  
  def get_report_for(reports_form, for_day, project_id = "")
    activities = []
    reports_form.fields_with(:name => "project_id").first.options_with(:value => project_id).first.select if project_id.present?
    reports_form["date_period[start]"] = for_day.strftime("%m/%d/%Y")
    reports_form["date_period[finish]"] = for_day.strftime("%m/%d/%Y")
    report = reports_form.submit
    for story in report.search("//div[@class='content_subsection has_dotted_line progress_story']")
      title   = story.search("span[@class='progress_story_name']/text()").to_s
      state  = story.search("span[@class='progress_story_state']/text()").to_s
      for row in story.search("table//tr")
        ary = row.search("td[@class='progress_command_description']/text()").to_s.split(" ")
        activity = create_activity(ary, row, title).to_a
        activities << activity
      end
    end
    activities
  end
  
end