class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :keep_user_at_production_domain

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    default_sign_in_path = if resource.respond_to?(:volunteer?) && resource.volunteer?
                             root_path(anchor: "projects")
                           else
                             root_path
                           end
    request.env['omniauth.origin'] || stored_location_for(resource) || default_sign_in_path
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

