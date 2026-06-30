module Ver1
  module Responses
    class TaskDeleteResponse < Dry::Struct
      attribute :count, Types::Integer
    end
  end
end
