class Tag < ApplicationRecord
  has_many :task_tags
  has_many :tasks, through: :task_tags

  def self.upsert_from_names(tag_names)
    Tag.upsert_all(
      tag_names.map { |name| { name: name } },
      unique_by: :name,
      update_only: [],
      returning: :id
    )
  end
end
