class PasswordResetsController < ApplicationController
  layout "application-old"

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    user.send_password_reset if user
    redirect_to root_url, flash: { notice: "Email sent with password reset instructions." }
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    redirect_to new_password_reset_path, flash: { error: "Password reset has expired." } if @user.password_reset_sent_at < 2.hours.ago
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, flash: { error: "Password reset has expired." }
    else
      @user.password_reset_sent_at = 30.days.ago
      if @user.update_attributes(params[:user])
        sign_in @user
        redirect_to @user, flash: { success: "Password has been reset!" }
      else
        render :edit
      end
    end
  end


end
