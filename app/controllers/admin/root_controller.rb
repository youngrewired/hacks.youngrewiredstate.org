class Admin::RootController < Admin::BaseController
  def index
  end

private
  def active_events
    @active_events ||= Event.active
  end
  helper_method :active_events
end
