class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :nav_state

  protected

  # Sorcery automatically looks for a method called not_authenticated
  def not_authenticated
    redirect_to new_session_path, :alert => "Please login first."
  end

  def nav_state
    # To be overwritten by controllers
  end
end
