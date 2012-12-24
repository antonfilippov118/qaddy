class LaunchrockController < ApplicationController
  layout "launchrock"

  def index
    redirect_to action: "launch"
  end

  def launch
  end

end
