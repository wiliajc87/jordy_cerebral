class ApplicationController < ActionController::Base
  private

  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

  def sessioned_user?
    @user.id == session[:current_user_id].to_i
  end
end
