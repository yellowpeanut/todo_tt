module Ver1
  module Contracts
    class TaskContractBase < Dry::Validation::Contract
      include ::Enums
      params do
        optional(:status).maybe(:string)
        optional(:scheduled_at).maybe(:date_time)
        optional(:recurrence)
        optional(:tags).array(:string)
      end

      rule(:status) do
        if value.present? and !TaskStatus.include?(value)
          key.failure("invalid status #{value}")
        end
      end

      rule(:scheduled_at) do
        if value.present? and value < Date.today
          key.failure("date must be in the future")
        end
      end

      rule(:recurrence) do
        if value.present?
          result = RecurrenceContract.new.call(value)
          unless result.success?
            result.errors.each do |error|
              key([ :recurrence ] + error.path).failure(error.text)
            end
          end
        end
      end

      rule(:tags) do
        if value.present?
          value.each do |tag|
            unless Tag.include?(tag)
              key.failure("invalid tag #{tag}")
            end
          end
        end
      end
    end
  end
end
