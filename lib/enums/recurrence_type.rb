module Enums
  class RecurrenceType
    ONCE = "once"
    ON_ODD = "on_odd"
    ON_EVEN = "on_even"
    DAILY = "daily"
    WEEKLY = "weekly"
    MONTHLY = "monthly"
    YEARLY = "yearly"

    def self.all
      constants(false).map(&method(:const_get)).freeze
    end

    def self.without_frequency
      [ ONCE, ON_ODD, ON_EVEN ].freeze
    end

    def self.include?(object)
      all.include?(object.to_s.downcase)
    end

    def self.without_frequency?(object)
      without_frequency.include?(object.to_s.downcase)
    end
  end
end
