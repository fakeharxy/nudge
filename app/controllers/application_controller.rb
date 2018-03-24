class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_urgency
  
  def set_urgency
    @urgencies = current_user.notes.return_urgencies if user_signed_in?
  end
end
