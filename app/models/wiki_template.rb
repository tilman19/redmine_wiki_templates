class WikiTemplate < ActiveRecord::Base
  include Redmine::SafeAttributes

  unloadable

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates :author_id, :presence => true
  validates :project_id, :presence => true
  validates :name, :presence => true

  scope :owned_by, ->(project_id) { where(:project_id => project_id) }
  scope :public, -> { where(:is_public => true) }
  scope :others_available, ->(project_id) { where("wiki_templates.is_public = ? and project_id != ?", true, project_id) }
  scope :sort_by_name, -> { order("name ASC") }
  scope :sort_by_proj, -> { joins(:project).order("projects.name ASC, name ASC") }

  safe_attributes 'name', 'text', 'is_public'
end
