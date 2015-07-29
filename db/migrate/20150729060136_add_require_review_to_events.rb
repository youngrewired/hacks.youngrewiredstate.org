class AddRequireReviewToEvents < ActiveRecord::Migration
  def change
    add_column :events, :require_review, :boolean, default: false
  end
end
