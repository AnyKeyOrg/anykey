class HomeController < ApplicationController

  def index
    @pledges_count = Pledge.count
  end
  
end
