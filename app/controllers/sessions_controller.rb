class SessionsController < ApplicationController

  # GET /sessions/new
  def new
  end

  # POST /sessions
  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash.now[:alert] = 'Invalid email and/or password'
      render :new
    end
  end

  # DELETE /sessions
  def destroy
    session[:user_id] = nil
    redirect_to home_path
  end

end
