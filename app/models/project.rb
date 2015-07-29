class Project < ActiveRecord::Base
  belongs_to :event
  belongs_to :centre

  has_paper_trail

  acts_as_ordered_taggable

  default_scope -> { order('title ASC') }
  scope :reviewed, -> { where(reviewed: true) }
  scope :unreviewed, -> { where(reviewed: false) }

  has_many :awards
  has_many :award_categories, :class_name => 'AwardCategory', :through => :awards

  accepts_nested_attributes_for :awards, :reject_if => :all_blank, :allow_destroy => true

  has_attached_file( :image, Rails.application.config.attachment_settings.merge({
    :styles => {
      :full => ["2160x1280#", :jpg],
    }
  }) )

  comma do
    title "Project Name"
    team "Team"
    summary "Description"
    project_url
    url "URL"
    notes
  end

  attr_accessor :submitted_secret

  before_validation :create_slug, :if => proc { self.slug.blank? and ! self.title.blank? }

  validates :title, :team, :description, :presence => true
  validates :centre, :presence => true, :if => proc { |a| a.event.use_centres == true }
  validates :secret, :presence => true, :on => :create

  validates :url, :code_url, :github_url, :svn_url, :format => { :with => URI::regexp, :allow_blank => true }

  validates :slug, :uniqueness => { :case_sensitive => false }

  validates_attachment :image, presence: true,
                               content_type: {
                                 content_type: ["image/jpeg", "image/gif", "image/png"]
                               },
                               size: {
                                 less_than: 5.megabytes,
                               }

  def update_attributes_with_secret(submitted_secret, attributes)
    if valid_secret?(submitted_secret)
      update_attributes(attributes)
    else
      self.errors.add(:submitted_secret, 'is not correct')
      return false
    end
  end

  def to_param
    self.slug
  end

  def format_url(url)
    url_parts = url.match(/https?:\/\/(.*)/i)
    url_parts ? url_parts[1].sub(/\/$/i,'') : url
  end

  def tag_list_with_hashes
    @tags_list_cache || tags.map {|t| "##{t.name}" }.join(" ")
  end

  def tag_list_with_hashes=(value)
    @tags_list_cache = value
    self.tag_list = value
  end

  def set_filename
    self.slug + Time.now.strftime('%s')
  end

  def has_won_award?
    (self.awards.count > 0) ? true : false
  end

  def notes
    ""
  end

  def project_url
    "http://hacks.rewiredstate.org" + Rails.application.routes.url_helpers.event_project_path(self.event, self)
  end

  def approve
    update_attribute(:reviewed, true)
  end

  private
    def create_slug
      existing_slugs = Project.all.select {|a| a.slug.match(/^#{self.title.parameterize}(\-[0-9]+)?$/)  }.size
      self.slug = (existing_slugs > 0 ? "#{self.title.parameterize}-#{existing_slugs+1}" : self.title.parameterize)
    end

    def valid_secret?(submitted_secret)
      submitted_secret.present? &&
        submitted_secret == secret
    end
end
