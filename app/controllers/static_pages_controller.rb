class StaticPagesController < ApplicationController
  respond_to :html, :json

  def landing
  end

  def index
  end

  # POST '/signup', as: :static_pages#signup
  # params: SignupBeta
  def signup
    raise error "Unsupported format" if !request.xhr?

    @signup = SignupBeta.new(params[:signup_beta])
    @signup.ip_address = request.headers['X_FORWARDED_FOR'] ||= env['REMOTE_ADDR']

    respond_to do |format|
      if @signup.save
        format.json  { render json: @signup, status: :created, :location => nil }
      else
        body = { errors: @signup.errors.full_messages }
        format.json  { render json: body, status: :unprocessable_entity }
      end
    end
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
