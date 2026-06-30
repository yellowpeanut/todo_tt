module Enums
  class WeekDays
    MONDAY = "monday"
    TUESDAY = "tuesday"
    WEDNESDAY = "wednesday"
    THURSDAY = "thursday"
    FRIDAY = "friday"
    SATURDAY = "saturday"
    SUNDAY = "sunday"

    def self.all
      constants(false).map(&method(:const_get)).freeze
    end

    def self.include?(object)
      all.include?(object.to_s.downcase)
    end
  end
end
