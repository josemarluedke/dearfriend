class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :keep_user_at_production_domain

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected
  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def keep_user_at_production_domain
    if /dear\-friend\.r12\.railsrumble\.com/.match(request.host)
      redirect_to "http://dearfriend.cc/"
    end
  end
end

