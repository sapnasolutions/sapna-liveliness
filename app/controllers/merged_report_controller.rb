class MergedReportController < ApplicationController
  before_filter :remove_top_menu
  
  def new
  end
  
  def create
  end
  
  #######
  private
  #######
  
  def remove_top_menu
    @no_separate_divs = true
  end

end
