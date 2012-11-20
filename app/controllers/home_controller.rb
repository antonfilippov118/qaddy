class HomeController < ApplicationController
  def index
    redirect_to :action => "signup"
  end

  def signup
    render "signup"
  end

end
