class Task < ApplicationRecord
  has_many :task_tags
  has_many :tags, through: :task_tags

  scope :root, -> { where(root_id: nil) }

  def self.root?(task)
    task.root_id.nil?
  end
end
