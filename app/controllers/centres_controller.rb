class CentresController < ApplicationController
  before_filter :set_breadcrumbs

  def show
  end

  def centre
    @centre ||= event.centres.find_by_slug(params[:id]) || not_found
  end
  helper_method :centre

  def event
    @event ||= Event.find_by_slug(params[:event_id]) || not_found
  end
  helper_method :event

private

  def set_breadcrumbs
    breadcrumbs.add event.title, event_path(event)
    breadcrumbs.add centre.name, event_centre_path(event, centre)
  end

end
