class HomeController < ApplicationController

  def index
    @pledges_count = Pledge.cached_count
  end
  
end
