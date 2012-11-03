class HomeController < ApplicationController
  def index
    redirect_to :action => "signup"
  end

  def signup
    render "signup", :layout => "signup"
  end
end
