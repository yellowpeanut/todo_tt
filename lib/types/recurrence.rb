module Types
  include Dry.Types
  class Recurrence < Dry::Struct
    transform_keys { |key| key.to_sym }

    attribute :type,         Types::String
    attribute? :week_days, Types::Array.of(Types::String).optional
  end
end