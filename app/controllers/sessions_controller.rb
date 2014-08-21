class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash.now[:alert] = 'Invalid email and password'
      render :new
    end
  end

  def destroy
    # TODO: test this
    session[:user_id] = nil
    redirect_to home_path
  end
end
