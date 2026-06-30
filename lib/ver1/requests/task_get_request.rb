module Ver1
  module Requests
    class TaskGetRequest < Dry::Struct
      attribute? :id,         Types::Integer.optional
      attribute :start_date, Types::Date
      attribute :end_date,   Types::Date
    end
  end
end