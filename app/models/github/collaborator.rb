module Github
  class Collaborator
    
    attr_reader :repository
    attr_reader :name
    
    def initialize(repository, name)
      @repository = repository
      @name   = name
    end
    
  end
end