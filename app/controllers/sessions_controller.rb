class SessionsController < ApplicationController
  layout "application-old"

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # store old session data, reset the session uid (session fixation protection) and restore old session data
      # temp_session = session.dup
      reset_session
      # session.replace(temp_session)


      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    sign_out
    reset_session
    redirect_to root_path
  end

end
