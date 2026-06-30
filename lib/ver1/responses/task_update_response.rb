module Ver1
  module Responses
    include ::Types
    class TaskUpdateResponse < Dry::Struct
      attribute :id,           Types::Integer
      attribute :title,        Types::String
      attribute :description,  Types::String
      attribute :status,       Types::String
      attribute :scheduled_at, Types::DateTime
      attribute :recurrence,   Types.Constructor(::Types::Recurrence)
      attribute :tags,         Types::Array.of(Types::String)
      attribute :created_at,   Types::DateTime
      attribute :updated_at,   Types::DateTime

      def to_h
        { uid: Types::TaskUid.new(id, scheduled_at) }.merge(super)
      end
    end
  end
end
