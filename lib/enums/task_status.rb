module Enums
  class TaskStatus
    ACTIVE = "active"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

    def self.all
      constants(false).map(&method(:const_get)).freeze
    end

    def self.include?(object)
      all.include?(object.to_s.downcase)
    end
  end
end
