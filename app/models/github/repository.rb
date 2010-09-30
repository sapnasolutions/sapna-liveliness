require 'octopussy'

module Github
  class Repository
    
    attr_reader :client
    attr_reader :login, :password
    attr_reader :name
    
    def initialize(client, login, password, name)
      @client = client
      @login  = login; @password = password
      @name   = name
    end
    
    def self.all(login, password)
      return [] unless login and password
      
      client = Octopussy::Client.new(:login => login, :token => password)
      return [] unless client
      
      return client.list_repos.map { |hash|
        Github::Repository.new(client, login, password, hash.name)
      }
    end
    
    def repository
      client.repo("#{login}/#{name}")
    end
    
    def client
      return @client
    end
    
    def collaborators
      return [] unless @client and @login and @password
      self.client.collaborators({:username => @login, :name => @name}).map { |hash|
        Github::Collaborator.new(self, hash)
      }
    end
    
    def generate_report(params)
      commits = []
      begin
        start_date  = get_date_from_string(params[:report][:from])
        end_date    = get_date_from_string(params[:report][:to])
        emails = []
        for user in params[:github][:users]
          emails << client.user(user).email
        end
        for branch in params[:github][:branches]
          response = client.class.get("http://github.com/api/v2/json/commits/list/#{login}/#{name}/#{branch}", :query => {:login => login, :token => password})
          commits << Hashie::Mash.new(response).commits
        end
        commits.flatten!
        commits = commits.select{|commit| emails.include?(commit.author.email) || params[:github][:users].include?(commit.author.login)}
        commits = commits.select{|commit| Date.parse(commit.committed_date) >= start_date && Date.parse(commit.committed_date) <= end_date}
      rescue Exception => e
        RAILS_DEFAULT_LOGGER.error e.message
      end
      return commits
    end
    
    #######
    private
    #######
    
    def get_date_from_string(date)
      month, day, year = date.split("-")
      Date.parse("#{year}/#{month}/#{day}")
    end
  end
end