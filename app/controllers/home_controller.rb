class HomeController < ApplicationController
  def index
  	@message = Message.new
  	@showForm = true
  end

  def send_email
  	@message = Message.new(params[:message])
    if @message.valid?
    	@message = Message.find_or_create_by_email(@message.email)
      # redirect_to(root_path, :notice => "Message was successfully sent.", :showForm => false)
  		@showForm = false
      render :index
    else
  		@showForm = true
      flash.now.alert = "There was a problem with your submission, please check the form for errors."
      render :index
    end  	
  end
end
