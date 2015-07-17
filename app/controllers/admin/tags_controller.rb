class Admin::TagsController < Admin::BaseController
  before_filter do
    breadcrumbs.add "Tags", admin_tags_path
  end

  def index
  end

  def destroy
    tag.destroy

    flash.notice = "Tag ##{tag.name} deleted."
    redirect_to admin_tags_path
  end

  def tags
    @tags ||= ActsAsTaggableOn::Tag.includes(:taggings).order('name asc').all
  end
  helper_method :tags

  def tag
    @tag ||= ActsAsTaggableOn::Tag.find(params[:id])
  end
  helper_method :tags
end
