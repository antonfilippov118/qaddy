class StaticPagesController < ApplicationController
  respond_to :html, :json

  def landing
  end

  def index
  end

  # POST '/signup', as: :static_pages#signup
  # params: company, first_name, last_name, email, url
  def signup
    raise error "Unsupported format" if !request.xhr?

    errors = Array.new
    error = false

    signup = SignupBeta.new(
      company: params[:company],
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      url: params[:url],
      ip_address: request.headers['X_FORWARDED_FOR'] ||= env['REMOTE_ADDR']
    )

    if !signup.valid?
      error = true
      errors = signup.errors.full_messages
    else
      signup.save!
    end

    body = { error: error, errors: errors }
    render json: body
  end

  # def about
  # end

  # def contact
  # end

  # def help
  # end

  # def news
  # end

end
