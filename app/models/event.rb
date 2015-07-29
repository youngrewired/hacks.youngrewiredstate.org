class Event < ActiveRecord::Base
  has_many :projects
  has_many :award_categories
  has_many :centres

  has_many :awards, :through => :award_categories
  has_many :award_winners, :through => :awards, :source => :project

  before_validation :create_slug, :if => proc { self.slug.blank? and ! self.title.blank? }

  accepts_nested_attributes_for :award_categories, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :centres, :reject_if => :all_blank

  validates :title, :slug, :presence => true
  validates :slug, :uniqueness => { :case_sensitive => false }

  scope :recent_first, -> { order("start_date desc") }
  scope :active, -> { where(enable_project_creation: true) }

  def to_param
    self.slug
  end

  def winners
    featured_award_categories.map(&:award_winners).flatten.uniq
  end

  def featured_award_winners_by_level
    featured_award_categories.group_by(&:level).map {|level, categories|
      winners = categories.map(&:award_winners).flatten.uniq
      [level, winners]
    }
  end

  def featured_award_categories
    award_categories.featured
  end

  def other_award_categories
    award_categories.not_featured
  end

  def has_secret?
    !self.secret.blank?
  end

  def visible_projects
    if require_review?
      projects.reviewed
    else
      projects
    end
  end

  private
    def create_slug
      existing_slugs = Event.all.select {|a| a.slug.match(/^#{self.title.parameterize}(\-[0-9]+)?$/)  }.size
      self.slug = (existing_slugs > 0 ? "#{self.title.parameterize}-#{existing_slugs+1}" : self.title.parameterize)
    end
end
