module PivotalTracker
  BASE_REST_URL = "http://www.pivotaltracker.com/services/v3"  
  
  def self.symbol_to_class(symbol)
    Kernel.const_get(symbol.to_s.singularize.camelcase)
  end
  
  def base_find(clazz, params)
    finds = clazz.send("find", :all, params)
    finds.map{ |x| x.project_id = self.id }
    return finds
  end
end