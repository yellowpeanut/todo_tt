module Ver1
  module Requests
    include ::Types
    class TaskUpdateRequest < Dry::Struct
      include ::Types
      attribute? :uid,          Types::String.optional
      attribute? :id,           Types::Integer.optional
      attribute? :title,        Types::String.optional
      attribute? :description,  Types::String.optional
      attribute? :status,       Types::String.optional
      attribute? :scheduled_at, Types::DateTime.optional
      attribute? :recurrence,   ::Types::Recurrence.optional
      attribute? :tags,         Types::Array.of(Types::String).optional
    end
  end
end