ActionController::Routing::Routes.draw do |map|
  map.resources :home, :only => [:index]
  map.namespace :pivotal_tracker do |pivotal_tracker|
    pivotal_tracker.resources :sessions, :only => [:new, :create, :destroy]
    pivotal_tracker.resources :projects, :only => [:index] do |project|
      project.resources :members, :only => [:index]
    end
  end
  map.connect '/projects/:project_id/members/:member_id/reports', 
    :controller => "pivotal_tracker/reports",
    :action     => :new,
    :conditions => {:method => :get}
    map.connect '/projects/:project_id/members/:member_id/reports', 
      :controller => "pivotal_tracker/reports",
      :action     => :create,
      :conditions => {:method => :post}
  
  map.root :controller => :home
end
