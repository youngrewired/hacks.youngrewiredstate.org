object @project

attributes :title, :team, :image_url, :description, :twitter, :github_url, :code_url
attribute :url => :project_url
attribute :tag_list_with_hashes => :tag_list

child :tags do
  attribute :name
  code(:formatted_name) {|t| "##{t.name}" }
end

code(:url) {event_project_url(@event, @project)}

child :award_categories => :awards do
  attribute :title, :description
end

child :event do
  attribute :title
  code(:url) {|e| event_url(e)}
end
