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
    
    def collaborators
      return [] unless @client and @login and @password
      self.client.collaborators({:username => @login, :name => @name}).map { |hash|
        Github::Collaborator.new(self, hash)
      }
    end
    
  end
end