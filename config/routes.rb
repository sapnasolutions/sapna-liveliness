ActionController::Routing::Routes.draw do |map|
  map.resources :home, :only => [:index]
  map.namespace :pivotal_tracker do |pivotal_tracker|
    pivotal_tracker.resources :sessions, :only => [:new, :create, :destroy]
    pivotal_tracker.resources :reports, :only => [:create]
    pivotal_tracker.resources :projects, :only => [:index] do |project|
      project.resources :members, :only => [:index]
    end
  end
  
  
  map.namespace :github do |github|
    github.resources :sessions, :only => [:new, :create, :destroy]
    github.resources :repositories, :only => [:index], :member => {:collaborators => :get}
    github.resources :reports, :only => [:create]
    github.collaborators_github_repository 'repositories/:id/collaborators', :controller => "repositories",  :action => "collaborators" 
  end
  
  map.resource :merged_report, :only => [:new, :create]
  #map.merged_report 'merged_report', :controller => :merged_report, :action => :new
  #map.generate_merged_report 'merged_report', :controller => :merged_report, :action => :create
      
  map.root :controller => :home
end
