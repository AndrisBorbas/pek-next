class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_login
    redirect_to oauth_login_path unless session[:user_id] || ENV['NONAUTH']
  end

  def correct_user
    @user = User.find_by(screen_name: params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  def require_leader
    if params[:group_id]
      @group = Group.find(params[:group_id])
    else
      @group = Group.find(params[:id])
    end
    @own_membership = current_user.membership_for(@group)
    unauthorized_page unless @own_membership && @own_membership.leader?
  end

  def current_user
    if ENV['NONAUTH']
      return impersonate_user
    end
    @user ||= User.find(session[:user_id])
  end
  helper_method :current_user

  def impersonate_user
    @user ||= User.first
  end

  def unauthorized_page
    render 'application/401'
  end
end
