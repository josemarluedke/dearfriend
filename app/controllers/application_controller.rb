class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected
  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end
end

