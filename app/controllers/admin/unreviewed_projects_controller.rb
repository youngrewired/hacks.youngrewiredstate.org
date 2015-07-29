class Admin::UnreviewedProjectsController < Admin::BaseController
  before_filter do
    breadcrumbs.add "Events", admin_events_path
    breadcrumbs.add event.title, edit_admin_event_path(event)
    breadcrumbs.add "Review projects", admin_event_projects_path(event)
  end

  def index
    if unreviewed_projects.any?
      redirect_to(
        admin_event_unreviewed_project_path(event, unreviewed_projects.first)
      )
    else
      flash.alert = 'There are no more projects that require review.'
      redirect_to(admin_event_projects_path(event))
    end
  end

  def show
  end

  def approve
    project.approve

    flash.notice = 'Project has been approved.'
    redirect_to(admin_event_unreviewed_projects_path(event))
  end

  def reject
    project.destroy

    flash.notice = 'Project has been rejected.'
    redirect_to(admin_event_unreviewed_projects_path(event))
  end

  def unreviewed_projects
    @projects ||= event.projects.unreviewed.order('created_at ASC')
  end
  helper_method :unreviewed_projects

  def project
    @project ||= unreviewed_projects.find_by_slug(params[:id])
  end
  helper_method :project

  def event
    @event ||= Event.find_by_slug(params[:event_id])
  end
  helper_method :event

private

end
