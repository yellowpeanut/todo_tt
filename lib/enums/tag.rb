module Enums
  class Tag
    REPORT = "report"
    OPERATION = "operation"
    CALL = "call"

    def self.all
      constants(false).map(&method(:const_get)).freeze
    end

    def self.required
      [ REPORT, OPERATION, CALL ].freeze
    end

    def self.include?(object)
      all.include?(object.to_s.downcase)
    end

    def self.required?(object)
      required.include?(object.to_s.downcase)
    end
  end
end
