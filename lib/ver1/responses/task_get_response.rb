module Ver1
  module Responses
    class TaskGetResponse < Dry::Struct
      attribute :tasks, Types::Array.of(TaskGetItem)

      def to_h
        {
          data: tasks.map(&:to_h),
          count: tasks.length
        }
      end

      def to_json
        to_h.to_json
      end
    end
  end
end
