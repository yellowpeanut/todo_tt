module Types
  class TaskUid
    def self.new(id, scheduled_at)
      "#{id}@#{scheduled_at}"
    end

    def self.split(object)
      object.split("@")
    end
  end
end
