class AddReviewedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :reviewed, :boolean, default: false
  end
end
