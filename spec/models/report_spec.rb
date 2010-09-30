require File.dirname(__FILE__) + '/../spec_helper'
require 'pivotal_tracker/project'

describe Report, "Test the report generation for pivotal tracker reports" do
  
  def get_valid_token_with_correct_login_and_password(login = "aashish@sapnasolutions.com", password = "n33d2c0nf!rm")
    @token = PivotalTracker::Token.get_token(login, password)
  end
  
  def get_all_projects(token)
    @projects = PivotalTracker::Project.all(token)
  end
  
  def get_project
    @project = @projects[rand(@projects.length - 1)]
  end
  
  def get_members
    @members = @project.memberships
  end
  
  def get_member
    @member = @members[rand(@members.length - 1)]
  end
  
  it "should not be valid" do
    report = Report.new
    report.should_not be_valid
    report.valid?.should be_false
  end
  
  it "should be valid" do
    report = Report.new({:report => {:from => "09-01-2010", :to => "09-03-2010"}}, 
                        {  :pivotal_tracker_username => "sapnasolutions", 
                           :pivotal_tracker_token => "21d89d777863caa9fa4ae80b14a1d70e", 
                           :pivotal_tracker_project_id => "someid"
                        })
    report.should be_valid
    report.valid?.should be_true
  end
  
  it "should not get a valid token with invalid login and password" do
    token = get_valid_token_with_correct_login_and_password("crazyscorpio12@gmail.com", "sdfsdfddfgdf")
    token.should be_nil
  end
  
  it "should generate report" do
    get_valid_token_with_correct_login_and_password
    @token.should_not be_nil
  
  #it "should get all projects with valid token" do
    get_all_projects(@token)
    @projects.should_not be_empty
  
  #it "should get member list" do
    get_project
    get_members
    @members.should_not be_empty
  
  #it "should generate report" do
    get_member
    project_id  = @project.id
    start_date  = "09-01-2010"
    end_date    = "09-30-2010"
    r = Report.new({  :report => {:from => start_date, :to => end_date},
                      :pivotal_tracker =>{:users => [@member.id.to_s]}
                   }, 
                   {  :pivotal_tracker_username => "sapnasolutions", 
                      :pivotal_tracker_token => @token,
                      :pivotal_tracker_project_id => project_id
                   })
    r.generate.should_not be_nil
  end
  
end