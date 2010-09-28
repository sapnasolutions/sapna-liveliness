module Github::SessionsHelper
  
  def projects_wrapper(&block)
    projects_and_repositories_base_wrapper({:type => :projects, :children => :members}, &block)
  end

  def repositories_wrapper(&block)
    projects_and_repositories_base_wrapper({:type => :repositories, :children => :collaborators}, &block)
  end
  
  private
  
  def projects_and_repositories_base_wrapper(options = {}, &block)
    options = {:body => capture(&block)}.merge(options)
    concat(render(:partial => "/github/projects_and_repositories", :locals => options), block.binding)
  end
  
end
