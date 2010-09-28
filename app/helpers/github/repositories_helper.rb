module Github::RepositoriesHelper
  
  def members_wrapper(&block)
    members_and_collaborators_base_wrapper({:type => :members, :parent => :projects}, &block)
  end
  
  def collaborators_wrapper(&block)
    members_and_collaborators_base_wrapper({:type => :collaborators, :parent => :repositories}, &block)
  end
  
  private
  
  def members_and_collaborators_base_wrapper(options = {}, &block)
    options = {:body => capture(&block)}.merge(options)
    concat(render(:partial => "members_and_collaborators", :locals => options), block.binding)
  end
  
end