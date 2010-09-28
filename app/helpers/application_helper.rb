# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def indicator(options = {})
    options = {:size => :small}.merge(options)
    render :partial => "/shared/indicator", :locals => { :options => options }
  end
  
end
