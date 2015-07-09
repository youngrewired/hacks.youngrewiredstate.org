class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private
    def after_sign_out_path_for(resource_or_scope)
      new_admin_session_path
    end
end
