module Ver1
  module Requests
    class TaskCreateRequest < Dry::Struct
      attribute :title,        Types::String
      attribute :description,  Types::String
      attribute? :status,    Types::String.optional
      attribute :scheduled_at, Types::DateTime
      attribute :recurrence,   Types.Constructor(::Types::Recurrence)
      attribute :tags,         Types::Array.of(Types::String)
    end
  end
end