class SessionsController < ApplicationController
  def new
  end

  def create
    # login is a Sorcery method
    @user = login(params[:email], params[:password])
    if @user
      redirect_to :root, :notice => "Welcome back"
    else
      flash.now[:alert] = "Invalid credentials. Try again?"
      render :new
    end
  end

  def destroy
    # Sorcery method
    logout
    redirect_to :root, notice: "Bye... Hope to see you later!"
  end
end
