require File.dirname(__FILE__) + '/../../spec_helper'

describe Github::Repository, "Test the report generation for pivotal tracker reports" do
  
  def get_username
    username = "your_username"
  end
  
  def get_api_token
    token = "your_api_token_here"
  end
  
  
  def get_repository
    Github::Repository.all(get_username, get_api_token).first
  end
  
  def get_branches(repository)
    repository.client.branches(get_username + "/#{repository.name}").keys
  end
  
  it "should not return repositories with incorrect credentials" do
    lambda{
    Github::Repository.all(get_username, get_api_token)
    }.should raise_error(Octopussy::Unauthorized)
  end
  
  it "should return all (including private) repositories for correct username and API token" do
    repositories = Github::Repository.all(get_username, get_api_token)
    repositories.should_not be_nil
  end
  
  it "should get respositry and collaborators" do
    repository = get_repository
    collaborators = repository.collaborators
    collaborators.should_not be_nil 
  end
  
  it "should generate report" do
    repository = get_repository
    collaborators = repository.collaborators
    branches = get_branches(repository)
    report = repository.generate_report(:report => {:from => "09-01-2010", :to => "09-03-2010"},
                               :github => {:users => collaborators.collect(&:name), :branches => branches}
                               )
    report.should_not be_nil
  end
  
end