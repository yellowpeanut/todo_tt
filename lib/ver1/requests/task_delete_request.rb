module Ver1
  module Requests
    class TaskDeleteRequest < Dry::Struct
      attribute :id,  Types::Integer
    end
  end
end